import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';
import { execFileSync } from 'node:child_process';

const [source, destination, moduleFile, voice = 'af_heart'] = process.argv.slice(2);
if (!source || !destination || !moduleFile) {
  throw new Error('Usage: narrate.mjs scenes.json NEW_OUTPUT_DIR kokoro-module.js [voice]');
}
const scenes = JSON.parse(await readFile(source, 'utf8'));
if (!Array.isArray(scenes) || !scenes.length || scenes.some(scene =>
  typeof scene.title !== 'string' || !scene.title.trim() ||
  typeof scene.text !== 'string' || !scene.text.trim())) {
  throw new Error('Scenes must be a nonempty array of {title, text} objects.');
}
execFileSync('ffprobe', ['-version'], { stdio: 'ignore' });
const dir = resolve(destination);
await mkdir(dir); // Refuse to overwrite a previous run.
const { KokoroTTS } = await import(pathToFileURL(resolve(moduleFile)).href);
const tts = await KokoroTTS.from_pretrained('onnx-community/Kokoro-82M-v1.0-ONNX', {
  dtype: 'q8', device: 'cpu'
});
const clips = [];
for (const [index, scene] of scenes.entries()) {
  const file = resolve(dir, `narration-${index}.wav`);
  const audio = await tts.generate(scene.text, { voice, speed: 1 });
  await audio.save(file);
  const duration = Number(execFileSync('ffprobe', [
    '-v', 'error', '-show_entries', 'format=duration', '-of', 'default=nw=1:nk=1', file
  ], { encoding: 'utf8' }).trim());
  if (!Number.isFinite(duration) || duration <= 0) throw new Error(`Invalid audio: ${file}`);
  clips.push({ ...scene, file, duration });
  console.log(`${index + 1}/${scenes.length}: ${duration.toFixed(2)}s — ${scene.title}`);
}
await writeFile(resolve(dir, 'narration.json'), JSON.stringify(clips, null, 2) + '\n');

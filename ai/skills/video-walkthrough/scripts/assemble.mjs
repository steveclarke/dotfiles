import { readFile, writeFile, mkdir, access } from 'node:fs/promises';
import { resolve } from 'node:path';
import { execFileSync } from 'node:child_process';

const [timelineFile, rawFile, destination] = process.argv.slice(2);
if (!timelineFile || !rawFile || !destination) {
  throw new Error('Usage: assemble.mjs timeline.json raw.webm NEW_OUTPUT_DIR');
}
const { times, end, videoStart } = JSON.parse(await readFile(timelineFile, 'utf8'));
if (!Array.isArray(times) || !times.length || !Number.isFinite(end)) {
  throw new Error('Timeline needs a nonempty times array and numeric end.');
}
for (const [index, scene] of times.entries()) {
  const next = times[index + 1]?.start ?? end;
  if (!Number.isFinite(scene.start) || scene.start < 0 ||
      !Number.isFinite(scene.duration) || scene.duration <= 0 ||
      typeof scene.text !== 'string' || !scene.text.trim() ||
      !Number.isFinite(next) || next < scene.start + scene.duration) {
    throw new Error(`Scene ${index + 1} has invalid timing or overlaps the next scene.`);
  }
  await access(scene.file);
}
const raw = resolve(rawFile);
const duration = Number(execFileSync('ffprobe', [
  '-v', 'error', '-show_entries', 'format=duration', '-of', 'default=nw=1:nk=1', raw
], { encoding: 'utf8' }).trim());
const origin = times[0].start;
const length = end - origin;
const offset = videoStart ?? Math.max(0, origin + duration - end);
if (!Number.isFinite(duration) || !Number.isFinite(offset) || offset < 0 ||
    offset + length > duration + 0.1) {
  throw new Error('Timeline does not fit the raw video. Check end or videoStart.');
}
const dir = resolve(destination);
await mkdir(dir);
const stamp = seconds => {
  const ms = Math.round(seconds * 1000);
  return `${String(Math.floor(ms / 3600000)).padStart(2, '0')}:${String(Math.floor(ms / 60000) % 60).padStart(2, '0')}:${String(Math.floor(ms / 1000) % 60).padStart(2, '0')},${String(ms % 1000).padStart(3, '0')}`;
};
const metadata = value => String(value).replace(/\r?\n/g, ' ').replace(/[\\=;#]/g, '\\$&');
let captions = '';
let count = 0;
for (const scene of times) {
  const sentences = scene.text.match(/[^.!?]+(?:[.!?]+|$)/g) ?? [scene.text];
  const total = sentences.reduce((sum, sentence) => sum + sentence.length, 0);
  let cursor = scene.start - origin;
  for (const sentence of sentences) {
    const seconds = scene.duration * sentence.length / total;
    captions += `${++count}\n${stamp(cursor)} --> ${stamp(cursor + seconds)}\n${sentence.trim()}\n\n`;
    cursor += seconds;
  }
}
await writeFile(resolve(dir, 'captions.srt'), captions);
await writeFile(resolve(dir, 'transcript.txt'), times.map(scene => scene.text).join('\n\n') + '\n');
await writeFile(resolve(dir, 'chapters.txt'), ';FFMETADATA1\ntitle=Feature walkthrough\n' +
  times.map((scene, index) => `[CHAPTER]\nTIMEBASE=1/1000\nSTART=${Math.round((scene.start - origin) * 1000)}\nEND=${Math.round(((times[index + 1]?.start ?? end) - origin) * 1000)}\ntitle=${metadata(scene.title ?? `Scene ${index + 1}`)}\n`).join(''));
const args = ['-hide_banner', '-n', '-ss', offset.toFixed(3), '-i', raw];
for (const scene of times) args.push('-i', resolve(scene.file));
args.push('-i', resolve(dir, 'captions.srt'), '-f', 'ffmetadata', '-i', resolve(dir, 'chapters.txt'));
const filters = times.map((scene, index) =>
  `[${index + 1}:a]adelay=${Math.round((scene.start - origin) * 1000)}:all=1[a${index}]`);
filters.push(times.map((_, index) => `[a${index}]`).join('') +
  `amix=inputs=${times.length}:normalize=0,loudnorm=I=-16:TP=-1.5:LRA=11[audio]`);
args.push('-filter_complex', filters.join(';'), '-map', '0:v:0', '-map', '[audio]',
  '-map', `${times.length + 1}:s`, '-map_metadata', String(times.length + 2),
  '-map_chapters', String(times.length + 2), '-c:v', 'libx264', '-preset', 'medium',
  '-crf', '21', '-pix_fmt', 'yuv420p', '-c:a', 'aac', '-b:a', '160k',
  '-c:s', 'mov_text', '-metadata:s:s:0', 'language=eng', '-t', length.toFixed(3),
  '-movflags', '+faststart', resolve(dir, 'walkthrough.mp4'));
execFileSync('ffmpeg', args, { stdio: 'inherit' });
console.log(JSON.stringify({ output: resolve(dir, 'walkthrough.mp4'), duration: length, offset }));

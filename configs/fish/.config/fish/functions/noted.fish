
function noted --argument filename
    set -l note_dir ~/Documents/notes

    if test -n "$filename"
        if test -e "$note_dir/$filename.md"
            echo "Opening note: $note_dir/$filename.md"
            nvim "$note_dir/$filename.md"
        else
            echo "Creating new note: $note_dir/$filename.md"
            touch "$note_dir/$filename.md"
            nvim "$note_dir/$filename.md"
        end
    else
        if test -e "$note_dir/$(date +%F).md"
            echo "Opening daily note: $note_dir/$(date +%F).md"
            nvim "$note_dir/$(date +%F).md"
        else
            echo "Creating new daily note from template"
            cp "$note_dir/templates/daily_note.md" "$note_dir/$(date +%F).md"
            sed -i "s/{{ date }}/$(date +%F)/g" "$note_dir/$(date +%F).md"
            nvim "$note_dir/$(date +%F).md"
        end
    end
end

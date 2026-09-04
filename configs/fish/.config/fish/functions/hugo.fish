# Hugo — Steve's executive coach assistant. Mirrors the zsh function in
# configs/zsh/.zshrc.
function hugo --description "cd to ~/src/hugo and open claude"
    if not test -d ~/src/hugo
        echo "Error: ~/src/hugo directory not found" >&2
        return 1
    end

    switch "$argv[1]"
        case -h --help
            echo "hugo              - cd to ~/src/hugo and open claude"
            echo "hugo [prompt]     - cd to ~/src/hugo and open claude with prompt"
            echo "hugo cd|-d        - cd to ~/src/hugo only"
            echo "hugo -r|--resume  - cd to ~/src/hugo and resume last session"
        case cd -d
            cd ~/src/hugo
        case -r --resume
            cd ~/src/hugo; and claude --resume
        case '*'
            cd ~/src/hugo; and claude $argv
    end
end

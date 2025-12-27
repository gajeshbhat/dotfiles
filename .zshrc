# Function to get current Git branch
function parse_git_branch() {
    git branch 2>/dev/null | sed -n 's/* \(.*\)/ (\1)/p'
}

# Set prompt with git branch
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{red}$(parse_git_branch)%f$ '
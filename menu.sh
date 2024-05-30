#!/bin/bash

# echo "VSCode path: $VSCODE_PATH"

clear

#Key folders
CODE_FOLDER_PATH="${HOME}/code"
JBI_FOLDER_PATH="${HOME}/.jbi"
COMMUNIFY_PATH="${CODE_FOLDER_PATH}/communify"
PRODUCT_TOOLS_PATH="${CODE_FOLDER_PATH}/product-tools"
CODE_ADMIN_PATH="${CODE_FOLDER_PATH}/code-admin"

#Color Variables for text
BLACK='\033[0;30m'
RED='\033[0;31m'
RED_U='\033[4;31m'
RED_BLINK='\033[5;31m'
GREEN='\033[0;32m'
GREEN_BLINK='\033[5;32m'
YELLOW='\033[0;33m'
YELLOW_BOLD='\033[1;33m'
PURPLE='\033[1;34m'
PURPLE_U='\033[4;34m'
PURPLE_BLINK='\033[5;34m'
PINK='\033[0;35m'
PINK_U='\033[4;35m'
PINK_BLINK='\033[5;35m'
LIGHTBLUE='\033[0;36m'
LIGHTBLUE_BOLD='\033[1;36m'
GRAY='\033[0;37m'
ORANGE='\033[1;91m'
BLUE='\033[1;94m'
CYAN='\033[1;96m'
WHITE='\033[1;97m'
MAGENTA='\033[1;95m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'

NC='\033[0m' # No Color

# Function to display the menu
show_menu() {
    echo -e "\n\n${LIGHTBLUE_BOLD}Hello! What would you like to do?"
    echo -e "Please choose one of the following options (enter the number):\n"
    echo -e "|-------------------------------------------------------------|${NC}\n"

    echo -e "${GREEN}0) Commit the current repository${NC}"
    echo -e "${PURPLE}1) Run Docker for Postgresql etc. ${NC}"
    echo -e "${PINK}2) Grant Terminal access to iCloud Drive ${NC}"
    echo -e "${GREEN}3) Run onetime initialization ${NC}"
    # echo -e "${LIGHTBLUE}3) OPEN MENU ${NC}"
    # echo -e "${YELLOW}4) Launch MyTech ${NC}"
    # echo -e "${PURPLE}5) Display Color Palette${NC}"
    # echo -e "${GREEN}6) Grant terminal access to iCloud Drive${NC} "
    # echo -e "${YELLOW}7) Restart Postgres 14${NC}"
    # echo -e "${GREEN}8) OPEN MENU ${NC}"
    # echo -e "${ORANGE}9) OPEN MENU ${NC}"
    # echo -e "${RED_U}10) Create/replace .jbi symbolic links${NC}"
    # echo -e "${RED_U}101) Generate an Encryption Key${NC}"
    # echo -e "${RED_U}1977) Deinitialize vscode${NC}"
    # echo -e "${RED_U}2008) DISCARD all changes and REPLACE with latest version from Azure Devops${NC}\n"

}

commit_current_folder() {

    echo "Comitting changes to current repository at: $pwd"
    git pull origin main
    git add .
    git commit -m "default commit message"
    git push origin main

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Commit Successful for ${PWD} ${NC}"
    else
        echo -e "${RED}!! ERROR !! Commit was not successful${NC}"
    fi

}
# Function to read the user's choice
read_choice() {
    local choice
    read -p "Enter choice [1 - 8]: " choice
    case $choice in

    0)
        echo "You chose Option 0"
        commit_current_folder
        ;;

    1)
        LOCAL_DATA_PATH="${HOME}/code/postgresql"
        LOCAL_PORT="5400"
        PORT_MAPPING="${LOCAL_PORT}:5432"

        # Enable this line to remove the existing PostgreSQL data
        # rm -rf "${LOCAL_DATA_PATH}"

        docker run \
            --name=mytech-postgresql \
            --hostname=mytech-postgresql-host \
            --env=POSTGRES_DB=mytech \
            --env=POSTGRES_PASSWORD=mytech \
            --env=POSTGRES_USER=mytech \
            --env=PGDATA=/var/lib/postgresql/data \
            --volume="${LOCAL_DATA_PATH}:/var/lib/postgresql/data" \
            --env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
            --env=LANG=en_US.utf8 \
            --network=platform_default -p "${PORT_MAPPING}" \
            --restart=no \
            --runtime=runc -d postgres:14-alpine

        # Wait for 5 seconds
        sleep 5

        # Attempt to connect to the PostgreSQL server
        psql -h localhost -p "${LOCAL_PORT}" -U mytech -d mytech

        ;;

    2)
        echo -e "${LIGHTBLUE} Grant Terminal access to iCloud Drive${NC}"
        echo -e "import os \nprint(os.path.expanduser('~/Library/Mobile Documents/com~apple~CloudDocs')) " >${HOME}/Library/Mobile\ Documents/com~apple~CloudDocs/terminal_access.py
        cd ${HOME}/Library/Mobile\ Documents/com~apple~CloudDocs
        python3 ${HOME}/Library/Mobile\ Documents/com~apple~CloudDocs/terminal_access.py
        echo -e "${GREEN}You should now have access to iCloud Drive in the terminal${NC}"
        exit 0

        ;;

    3)

        initialize

        ;;

    *)
        echo "Invalid choice. Exiting ..."
        exit 0
        ;;

    esac
}

# Function to ask for confirmation
confirm() {
    while true; do
        read -p "$1 ( ${PURPLE}Yy or ${PINK_U}Nn ${NC}): " yn
        case $yn in
        [Yy]*) return 0 ;;                                                     # User responded yes
        [Nn]*) return 1 ;;                                                     # User responded no
        *) echo "${RED_BLINK}Please answer Y for 'yes' or N for 'no'.${NC}" ;; # Invalid response
        esac
    done
}

initialize() {

    clear

    RED='\033[0;31m'
    GREEN='\033[0;32m'
    BLUE='\033[0;31m'
    NC='\033[0m' # No Color

    #Custom hidden root folder for JBI machines to install software
    HOME_DIR="${HOME}"
    cd "${HOME}"
    echo "Current directory is ${PWD} after cd to ${HOME_DIR}"

    JBI_FOLDER=".jbi"
    JBI_FOLDER_PATH="${HOME}/${JBI_FOLDER}"
    ARCHIVE_FOLDER_DATE_NAME="$(date '+%Y-%m-%d_%H-%M-%S')"
    ARCHIVE_FOLDER_DATE_PATH="${HOME}/.jbi-archive/${ARCHIVE_FOLDER_DATE_NAME}"
    echo "ARCHIVE_FOLDER_DATE_NAME is ${ARCHIVE_FOLDER_DATE_NAME}"
    echo "JBI_FOLDER is ${JBI_FOLDER} and ARCHIVE_FOLDER_DATE_NAME is ${ARCHIVE_FOLDER_DATE_NAME} and JBI_FOLDER_PATH is ${JBI_FOLDER_PATH}"

    # Check if the folder already exists, if so run some code
    if [ -d "${JBI_FOLDER_PATH}" ]; then
        echo "JBI folder already exists."

        # Create the archive directory
        mkdir -p .jbi-archive
        cd .jbi-archive
        mkdir -p $ARCHIVE_FOLDER_DATE_NAME

        cd "${HOME}"

        # Now move the folder
        echo "Since the JBI_FOLDER exists we are going to move ${JBI_FOLDER_PATH} to ${ARCHIVE_FOLDER_DATE_PATH}"
        mv "${JBI_FOLDER_PATH}" "${ARCHIVE_FOLDER_DATE_PATH}"

    fi
    echo "JBI folder does not exist."
    # Add your code here to run when the folder does not exist

    # Function to check if Homebrew is installed
    check_homebrew_installed() {
        if brew --version &>/dev/null; then
            echo "Homebrew is already installed."
            return 0
        else
            echo "Homebrew is not installed."
            return 1
        fi
    }
    # Function to install Homebrew
    install_homebrew() {
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to your PATH in /Users/yourname/.zprofile:
        eval "$(/opt/homebrew/bin/brew shellenv)"
    }
    # Function to check if Git is installed
    check_git_installed() {
        if git --version &>/dev/null; then
            echo "Git is already installed."
            return 0
        else
            echo "Git is not installed."
            return 1
        fi
    }
    # Function to install Git
    install_git() {
        echo "Installing Git..."
        brew install git
        echo "Installing github"
        brew install gh
    }

    # Check if Homebrew is installed, if not, install it
    if ! check_homebrew_installed; then
        install_homebrew
        if ! check_homebrew_installed; then
            echo "Failed to install Homebrew. Cannot proceed with Git installation."
            exit 1
        fi
    fi

    # Check if Git is installed, if not, install it
    if ! check_git_installed; then
        install_git
    fi

    # Confirm the installation
    if check_git_installed; then
        echo "Git installation was successful."
    else
        echo "Git installation failed."
        exit 1
    fi

    git clone https://github.com/MichaelOC23/macmini.git "${JBI_FOLDER_PATH}"

    # Use 'move' to rename the folder (. folders are hidden)
    # echo -p "about to mvoe setup to .jbi       "
    # mv "${HOME}/setup" "${JBI_FOLDER_PATH}"

    # Loop through each .sh file in the .jbi folder
    for file in "${JBI_FOLDER_PATH}"/*.sh; do
        # Check if the file exists to avoid errors with non-existent files
        if [ -f "$file" ]; then
            # Make the file executable
            chmod u+x "$file"
            echo "Made executable: $file"
        fi
    done

    # Define the line to add
    line_to_add='source "${HOME}/.jbi/env_variables.sh"'

    # Define the path to your .zshrc
    zshrc="$HOME/.zshrc"

    # Check if the line already exists in .zshrc
    if ! grep -Fxq "$line_to_add" "$zshrc"; then
        # If the line does not exist, append it
        echo "$line_to_add" >>"$zshrc"
        echo "Line added to .zshrc"
    else
        echo "Line already in .zshrc"
    fi

    source "${HOME}/.zshrc"
    echo "mini_init.sh script has been run successfully."

}

# Main logic loop
while true; do
    show_menu
    read_choice
done

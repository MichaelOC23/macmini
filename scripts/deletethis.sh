cd "${HOME}/.jbi" &&
    source jbi_venv/bin/activate &&
    export TFOLDER="XXX" &&
    python3 -m "${HOME}/.jbi/scripts/full_folder_text_extraction.py"

SKIP_LIST_FILE="${PWD}/skiplist.txt"

cd "File Path" && touch url_list.txt





cd "${HOME}/.jbi" &&
    source jbi_venv/bin/activate &&
    export TFOLDER="/Users/michasmi/Library/CloudStorage/OneDrive-SharedLibraries-JBIHoldingsLLC/Just Build It - Documents/Clients/Sageview/research/" &&
    python3 "${HOME}/.jbi/scripts/full_folder_text_extraction.py"
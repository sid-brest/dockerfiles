import os

# Define the folder path and the rows to replace
folder_path = "/usr/share/nginx/html/sertis/"
rows_to_replace = [ 
    ("<meta http-equiv=\"Content-Security-Policy\" content=\"upgrade-insecure-requests\">", ""),
    ("if (location.protocol === \"http:\")", ""),
    ("location.protocol = \"https:\";", ""),
        
]
# Iterate over all files in the folder
for filename in os.listdir(folder_path):
    if filename.endswith("html"):
        file_path = os.path.join(folder_path, filename)
        
        # Read the contents of the file
        with open(file_path, "r", encoding="utf-8") as file:
            file_content = file.read()
        
        # Replace the rows in the file content
        for old_row, new_row in rows_to_replace:
            file_content = file_content.replace(old_row, new_row)
        
        # Write the modified content back to the file
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(file_content)
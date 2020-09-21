def change_extension(file, new_extension):
  return file.basename[:-len(file.extension)] + new_extension

from pathlib import Path
import shutil

dest_dir: Path = Path.home()
dotfile_dir: Path = Path(dest_dir, "dotfiles")

dir_list: list[str] = [
    ".config/wezterm",
    ".config/yazi",
    ".config/nvim",
    ".config/bat",
    ".config/fish",
]

for d in dir_list:
    print(f"Symlinking '{d}'")
    try:
        if Path(dest_dir, d).is_symlink():
            Path(dest_dir, d).unlink()
        else:
            shutil.rmtree(Path(dest_dir, d), )
        Path(dest_dir, d).symlink_to(
            Path(dotfile_dir, d),
            target_is_directory=True,
        )
        print(f"Symlinked '{d}' to '{Path(dotfile_dir, d)}'")
    except (FileNotFoundError, OSError):
        pass

for f in dotfile_dir.glob(".*"):
    if f.is_file():
        try:
            Path(dest_dir, f.name).unlink()
        except FileNotFoundError:
            pass
        try:
            Path(dest_dir, f.name).symlink_to(Path(dotfile_dir, f.name))
            print(f"Symlinked '{f.name}' to '{Path(dotfile_dir, f.name)}'")
        except (FileNotFoundError, OSError):
            pass

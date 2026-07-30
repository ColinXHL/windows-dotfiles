// Open editable text and unregistered file types in Neovim inside Windows Terminal.
item(mode="single" type="file"
	where=path.exists(nvim_exe) && path.exists(terminal_exe) && (
		str.equals(str.lower(sel.file.ext), code_ext)
		|| sel.file.ext==""
		|| !reg.exists('HKCR\@sel.file.ext')
	)
	pos=0 title="通过 Neovim 打开"
	image=nvim_exe
	cmd=terminal_exe
	args='-w 0 new-tab --title Neovim --startingDirectory "@sel.parent" "@nvim_exe" "@sel.path"')

item(mode="single" type="file"
	where=path.exists(nvim_exe) && !path.exists(terminal_exe) && (
		str.equals(str.lower(sel.file.ext), code_ext)
		|| sel.file.ext==""
		|| !reg.exists('HKCR\@sel.file.ext')
	)
	pos=0 title="通过 Neovim 打开"
	image=nvim_exe
	cmd=nvim_exe
	args='"@sel.path"')

// Open editable text and unregistered file types in Neovim inside WezTerm.
item(mode="single" type="file"
	where=path.exists(nvim_exe) && path.exists(terminal_exe) && (
		str.equals(str.lower(sel.file.ext), code_ext)
		|| str.lower(sel.file.ext)==".ahk"
		|| sel.file.ext==""
		|| !reg.exists('HKCR\@sel.file.ext')
	)
	pos=0 title="通过 Neovim 打开"
	image=nvim_exe
	cmd=terminal_exe
	args='start --new-tab --cwd "@sel.parent" -- "@nvim_exe" "@sel.path"')

item(mode="single" type="file"
	where=path.exists(nvim_exe) && !path.exists(terminal_exe)
		&& str.lower(sel.file.ext)!=".ahk" && (
		str.equals(str.lower(sel.file.ext), code_ext)
		|| sel.file.ext==""
		|| !reg.exists('HKCR\@sel.file.ext')
	)
	pos=0 title="通过 Neovim 打开"
	image=nvim_exe
	cmd=nvim_exe
	args='"@sel.path"')

item(mode="single" type="dir"
	where=path.exists(nvim_exe) && path.exists(terminal_exe)
	pos=0 title="通过 Neovim 打开"
	image=nvim_exe
	cmd=terminal_exe
	args='start --new-tab --cwd "@sel.path" -- "@nvim_exe" .')

item(mode="none" type="back"
	where=path.exists(nvim_exe) && path.exists(terminal_exe)
	pos=0 title="通过 Neovim 打开"
	image=nvim_exe
	cmd=terminal_exe
	args='start --new-tab --cwd "@sel.workdir" -- "@nvim_exe" .')

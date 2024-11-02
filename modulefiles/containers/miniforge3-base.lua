--- Point to package 
local APP = "base"

--- Set up environment
load('Apptainer')

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
setenv("APPROOT", pathJoin('/projects', 'ok001', 'apptainer', 'apps'))
setenv("CONDAROOT", pathJoin(os.getenv('APPROOT'), 'miniforge3'))

set_alias(app , 'apptainer run 'os.getenv('APPROT'), os.getenv('APP'), '.sif'))
if (mode() == "unload");then
    unset("APPROOT", pathJoin('/projects/ok001/apptainer/apps'))
    unset("CONDAROOT", pathJoin(os.getenv('APPROOT'), 'miniforge3')
end

--- Description of software (`module whatis [module name]`)
whatis('Miniforge3 container')

--- Examples: How to use package (`module help [module name]`)
help([[]])

family('conda')


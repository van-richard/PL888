--- Point to package 
local TargetName     = "parallel2024"
local TargetPath     = "/scratch/van/Programs/"..TargetName

prepend_path(   "PATH"              , tostring(pathJoin(TargetPath, "bin")))

if (mode() == "unload") then
    remove_path( "PATH", tostring(pathJoin(TargetPath, "bin")))
end

--- Description of software (`module whatis [module name]`)
whatis('GNU Parallel 2024')
whatis('A shell tool for excuting jobs in parallel !!!')

--- Examples: How to use package (`module help [module name]`)
help([[
-----------------------------------------------------------------------

Example: Parallelizing `rsync`

    $ cd src-dir
    $ find . -type f | parallel -j10 -X rsync -zR -Ha ./{} fooserver:/dest-dir/

-----------------------------------------------------------------------

For more information:

    https://www.gnu.org/software/parallel/parallel.html
]])


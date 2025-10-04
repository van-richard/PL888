--- Point to package 
local TargetName     = "parallel2024"
local TargetPath     = "/scratch/van/Programs/"..TargetName

prepend_path(   "PATH"              , tostring(pathJoin(TargetPath, "bin")))

if (mode() == "unload") then
    remove_path( "PATH", tostring(pathJoin(TargetPath, "bin")))
end

--- Description of software (`module whatis [module name]`)
whatis('\
    Name: GNU Parallel\
    Description: \
        Shell tool for executing jobs in parallel using one or more computers \
        A job can be a single command or a small script that has to be run for each of the lines in the input \
        The typical input is a list of files, a list of hosts, a list of users, a list of URLs, or a list of tables \
')


--- Examples: How to use package (`module help [module name]`)
help([[
Example usage (Note: Only in `interactive` or SLURM script!):

To load the module:

1) `interactive` 

$ module load parallel/2024

2) SLURM 

module load parallel/2024

-----------------------------------------------------------------------

Example: Parallelizing `rsync`

    $ cd src-dir
    $ find . -type f | parallel -j10 -X rsync -zR -Ha ./{} fooserver:/dest-dir/

-----------------------------------------------------------------------

For more computational chemistry specific examples, visit my notes, and search "parallel":

    https://van-richard.github.io/CodingNotes

For more information:

    https://www.gnu.org/software/parallel/parallel.html
]])


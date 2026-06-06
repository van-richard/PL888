#!/usr/bin/env python3
import os
import sys
import argparse
import shutil
import subprocess

def slurm_available() -> bool:
    # Fast path: common SLURM env vars present when inside an allocation/job
    env_hit = any(os.getenv(v) for v in ("SLURM_JOB_ID", "SLURM_CLUSTER_NAME", "SLURM_JOB_PARTITION"))
    if env_hit:
        return True

    # On login nodes you may not have those vars; check tools + controller briefly.
    if not shutil.which("squeue"):
        return False

    try:
        # Short ping; returns 0 when controller reachable.
        out = subprocess.run(
            ["scontrol", "ping"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=1.5,
        )
        return out.returncode == 0
    except Exception:
        return False

def main():
    # Only run on SLURM hosts/sessions
    if not slurm_available():
        # Quietly do nothing (or print a hint if you prefer)
        # print("SLURM not available on this host/session.")
        sys.exit(0)

    parser = argparse.ArgumentParser()
    parser.add_argument('--username', '-u',
                        type=str, default=os.getenv('USER'),
                        help='HPC username')
    parser.add_argument('--repeat', '-r',
                        type=int, default=0,
                        help='run command every "-r" seconds')
    args, extra = parser.parse_known_args()

    # squeue format
    q_fmt = '%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R'

    # Build argv (no shell)
    cmd = ["squeue", "--format", q_fmt, f"--user={args.username}"]
    if args.repeat:
        cmd += ["--iterate", str(args.repeat)]
    # allow passing through any extra squeue flags
    cmd += extra

    # Replace current process with squeue
    os.execvp(cmd[0], cmd)

if __name__ == "__main__":
    main()


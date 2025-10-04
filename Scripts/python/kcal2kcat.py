#!/usr/bin/env python3
"""
kcal2kcat — Convert ΔG‡ (kcal/mol) to kcat using Eyring TST.

    k = (k_B T / h) * exp(-ΔG‡/(R T))

Defaults: T = 298.15 K, input ΔG‡ unit = kcal/mol, output rate unit = s^-1.
Supports batch input via --file or stdin. TSV/CSV output available.
"""
from __future__ import annotations
import argparse, sys, math

# Constants
R_KCAL = 1.98720425864083e-3   # kcal/(mol·K)
KB_SI  = 1.380649e-23          # J/K
H_SI   = 6.62607015e-34        # J·s

MIN_TO_S = 60.0
MS_TO_S  = 1e-3

def per_second_to_rate(k_s: float, unit: str) -> float:
    u = unit.lower()
    if u in {"s", "sec", "1/s", "s^-1"}: return k_s
    if u in {"min", "m", "1/min", "min^-1"}: return k_s * MIN_TO_S
    if u in {"ms", "1/ms", "ms^-1"}: return k_s * MS_TO_S
    raise ValueError(f"Unsupported rate unit: {unit!r}. Use s, min, or ms.")

def kcat_from_dg(dg_kcal: float, T: float) -> float:
    return (KB_SI * T / H_SI) * math.exp(-dg_kcal / (R_KCAL * T))

def parse_values(src):
    vals = []
    for line in src:
        line = line.strip()
        if not line or line.startswith('#'): continue
        try: vals.append(float(line))
        except ValueError: raise ValueError(f"Cannot parse numeric value from line: {line!r}")
    return vals

def main(argv=None) -> int:
    p = argparse.ArgumentParser(
            prog="kcal2kcat",
            formatter_class=argparse.ArgumentDefaultsHelpFormatter,
            description="Convert ΔG‡ (kcal/mol) → kcat using Eyring TST.",
            )
    p.add_argument("dg", nargs="?", type=float, default=-1*17.19, help="ΔG‡ value in kcal/mol; if omitted, use --file or stdin.")
    p.add_argument("--temp", "-t", type=float, default=298.15, help="Temperature in kelvin (Default: 298.15K)")
    p.add_argument("--file", "-f", type=str, help="Read values (one per line) from file" )
    p.add_argument("--out-unit", "-u", default="s", help="Output rate unit for kcat (s, min, ms)")
    args = p.parse_args(argv)

    # get inputs
    if len(sys.argv) == 1:  # no args
        p.print_help(sys.stdout)
        sys.exit(0)
    if args.dg is not None:
        inputs = [args.dg]
    elif args.file:
        with open(args.file, 'r') as fh: inputs = parse_values(fh)
    else:
        if not sys.stdin.isatty():
            inputs = parse_values(sys.stdin)
        else:
            p.error("Provide ΔG‡, --file, or pipe values via stdin.")

    try:
        for dg in inputs:
            k_s = kcat_from_dg(dg, args.temp)
            kout = per_second_to_rate(k_s, args.out_unit)
            print(f"\n\t               Temp (K): {args.temp:8.2f}",
                  f"\t\t      kcat (/{args.out_unit}): {kout:8.2e}",
                  f"\t\t ΔG‡ (kcal/mol):  {dg:.4f}\n",
                  sep="\n")
    except ValueError as e:
        print(f"error: {e}", file=sys.stderr); return 2
    return 0

if __name__ == '__main__':
    raise SystemExit(main())

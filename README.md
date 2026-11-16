# modix-community-resources

PrusaSlicer profiles and calibration prints for Modix Big-120Z and Big Meter
large-format 3D printers, from the FAST research group's labs and the labs we work
with.

## Profiles

[`profiles/`](profiles/) has one folder per printer setup:

| Folder | Printer |
| --- | --- |
| [`big-120z/`](profiles/big-120z/) | Big-120Z V4, single extruder; plus a 2020 config bundle |
| [`big-120z-idex/`](profiles/big-120z-idex/) | Big-120Z V4 IDEX: PETG with PLA support |
| [`big-meter/`](profiles/big-meter/) | Big Meter V4, single extruder, including 0.8 mm hardened steel nozzle profiles; plus a 2020 config bundle |
| [`big-meter-idex/`](profiles/big-meter-idex/) | Big Meter V4 IDEX: PETG with PLA support |

Each file sets only the values that differ from PrusaSlicer 2.9.7's defaults;
PrusaSlicer fills in the rest. Import a single profile with **File > Import >
Import Config**, and a `*-2020-bundle.ini` with **Import Config Bundle**. The
presets appear under names starting `FAST`.

## Calibration prints

[`objects/`](objects/) holds OpenSCAD sources and the STLs rendered from them:

- [`v4-calibration-jig/`](objects/v4-calibration-jig/): the V4 calibration jig.
- [`idex-test-cube/`](objects/idex-test-cube/): a test cube for IDEX printing.

To re-render after changing a source:

```sh
openscad --export-format binstl -o v4_calibration_jig.stl v4_calibration_jig.scad
```

## Credits

The profiles began from configurations supplied with the lab's Modix printers and
were rebuilt by the FAST research group on PrusaSlicer's defaults. The calibration
jig is modelled to the dimensions of Modix's V4 calibration jig. This project is not
affiliated with or endorsed by Modix Modular Technologies Ltd.; "Modix" is their
trademark.

## Licence

MIT. These are shared machine settings and calibration aids, not a project in their
own right, and are meant to be reused freely by anyone running these printers. That
makes them an exception to the FAST
[licensing policy](https://github.com/uwo-fast/.github/blob/main/LICENSING.md),
whose default is reciprocal.

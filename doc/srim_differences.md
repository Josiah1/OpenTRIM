# Differences from SRIM {#srim-diff}

OpenTRIM uses SRIM-2013 electronic stopping data and reproduces SRIM damage estimates closely, but it is not a drop-in replacement for every SRIM feature. This page lists what differs.

## Damage estimates

The benchmark in `test/srim_comp` compares 5 ions (1 MeV H, 1 MeV He, 3 MeV Al, 5 MeV Fe, 10 MeV Au) on 15 elemental targets (Li to U), 75 cases in total:

| SRIM mode | Median vacancy difference | Largest difference |
|---|---|---|
| Quick Cascade (QC) | 0.8% | 6.5% (1 MeV H in Li) |
| Full Cascade (FC), excluding Cu | 2.0% | 5.7% |
| Full Cascade (FC), Cu target | | +8% (H) to +19% (Au), unexplained |

- **Replacements:** in the 5 heavy-ion damage-profile benchmarks in `test/` (Fe in Fe, Xe in UO<sub>2</sub>), OpenTRIM counts 30–32% fewer replacement collisions than SRIM-FC (e.g. 3260 vs 4810 per ion for 2 MeV Fe in Fe), while vacancies agree within 4%. The 2 H benchmarks are similar, but SRIM reports only 7–21 events per ion there, rounded to integers. The replacement criterion is described in \ref damage-events. Compare vacancies, not replacements, between the two codes.
- **Light ions:** SRIM-FC distributes recoil damage along long free flight paths, which can create artificial peaks and dips in the damage profile of light ions. The SRIM workaround (monolayer mode) is described in `test/README.md`.

## Electronic stopping

- **Compound correction:** SRIM corrects Bragg's rule for chemical bonding in compounds. OpenTRIM applies such a correction only if you supply it: set \ref _Target_materials_0_compound_correction "compound_correction" for the material to SRIM's value ("Compound Correction (Bragg)" in the TRIM setup window). The default, 1, is plain Bragg's rule, which can be a few percent high for compounds such as plastics.
- **Gas targets:** SRIM's gas-phase stopping correction is not available.

## Energy range

The stopping tables cover ion energies from 16 eV to 2<sup>30</sup> eV ≈ 1.07 GeV (total kinetic energy, not per nucleon). SRIM goes up to 2 GeV/u. The scattering tables are bounded in reduced energy, so the limit is lower for light ions in light targets: with the default ZBL potential, about 258 MeV for H in water and 401 MeV for He in PMMA.

Configuration validation rejects an ion beam whose energy distribution exceeds the limit and reports the highest allowed energy for the given ion and target.

## Missing features

- **Sputtering:** the surface binding energy \ref _Target_materials_0_composition_0_Es "Es" is stored but not used in transport. There are no sputtering yields and no surface binding at exit.
- **Individual source ions:** there is no equivalent of SRIM's `TRIM.DAT` input to list individual starting ions with their own energy, position and direction.

# morgana

Bayesian flexible parametric survival models in Stata.

`morgana` is a prefix command for [`stmerlin`](https://github.com/RedDoorAnalytics/stmerlin). It fits the Royston-Parmar flexible parametric survival model by Bayesian estimation, using `bayesmh` with the likelihood from [`merlin`](https://reddooranalytics.se/software/merlin/).

## What it fits

After `stset`, `morgana` takes an `stmerlin` command with `distribution(rp)`, the Royston-Parmar model, and samples the posterior of its parameters.

- Only `distribution(rp)` is supported. Any other `stmerlin` distribution stops with an error (return code 198).
- `bayesmh` options go before the colon. The default prior on every parameter is `normal(0,10000)`. `prior()` sets the prior of one parameter, and `dryrun` lists the parameter names.
- There is no `predict` after `morgana`.

## Requirements

morgana 1.0.2 supports Stata 18 or later, merlin 2.5.0 and stmerlin 1.1.2. It does not support merlin 3.0.0.

- `merlin`:

```stata
net install merlin, from("https://reddooranalytics.se/install/stata/merlin/latest/")
```

- `stmerlin`:

```stata
net install stmerlin, from("https://reddooranalytics.se/install/stata/stmerlin/latest/")
```

## Installation

```stata
net install morgana, from("https://reddooranalytics.se/install/stata/morgana/latest/")
```

## Example

```stata
webuse brcancer, clear
stset rectime, failure(censrec)

// a Bayesian Royston-Parmar model
morgana : stmerlin hormon, distribution(rp) df(3)

// the same, with an informative prior on the hormon coefficient
morgana, prior({hormon}, normal(0.3,0.03)) : stmerlin hormon, distribution(rp) df(3)

// list the parameter names, for setting priors, without fitting
morgana, dryrun : stmerlin hormon, distribution(rp) df(3)
```

Further detail is in the help file: `help morgana`.

## Checked with

These three examples ran with merlin 2.5.0 and stmerlin 1.1.2 on Stata 19.5. On the `brcancer` data the posterior means of all five parameters of the first example lie within 0.025 of `stmerlin`'s maximum likelihood estimates, both with 1,000 draws after 500 burn-in and with the `bayesmh` defaults. Other data and other versions of Stata have not been checked.

## Version

Version 1.0.2.

**1.0.2.** The help file gives the current web address of merlin, the address of the morgana page and the author's full email address.

**1.0.1.** Only `distribution(rp)`, the Royston-Parmar model, is supported.

**1.0.0.** The first version, with the package dated 25 October 2023.

## Author and licence

Michael J. Crowther (Red Door Analytics, Stockholm) — `michael.crowther@reddooranalytics.se`.

Licence: **GPL-3.0-or-later** — see [`LICENSE`](LICENSE).

Copyright (C) 2023-2026 Red Door Analytics.

> **Licence change, 2026-10-09.** morgana was distributed under the MIT licence from 2023-08-16, when its LICENSE was added (the repository's first commit is 2023-07-09), until this change. It is **GPL-3 going forward**, as is
> the rest of the family. This is not retroactive: versions already released under MIT remain MIT for those versions.

"""Merged time-series figure (replaces Figs 3-5): 3 rows, shared x-axis.
Palette and typography match the paper's figure family.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.dates as mdates

mpl.rcParams.update({
    "font.family": "serif", "font.serif": ["DejaVu Serif"],
    "font.size": 8, "axes.linewidth": 0.6,
    "xtick.major.width": 0.6, "ytick.major.width": 0.6,
})

C_GAS = "#C6522B"   # L1 DA gas (DA cost, warm per convention)
C_FEE = "#2E7D6B"   # L2 fee (revenue, green per convention)
BAR = {"Arbitrum One": "#D2D6DB", "OP Mainnet": "#D2D6DB", "Base": "#D2D6DB"}

chains = [
    ("Arbitrum One", "arbitrum_timeseries.csv"),
    ("OP Mainnet",   "opmainnet_timeseries.csv"),
    ("Base",         "base_timeseries.csv"),
]
DENCUN = pd.Timestamp("2024-03-13")
PECTRA = pd.Timestamp("2025-05-07")

fig, axes = plt.subplots(3, 1, figsize=(7.16, 5.6), sharex=True,
                         gridspec_kw={"hspace": 0.14})

for k, (ax, (name, path)) in enumerate(zip(axes, chains)):
    df = pd.read_csv(path)
    df["day"] = pd.to_datetime(df["day"].str.replace(" UTC", ""), format="mixed")
    df = df.sort_values("day")
    gas = df["da_gas_eth"].rolling(7, min_periods=1).mean()
    fee = df["l2_fee_eth"].rolling(7, min_periods=1).mean()

    ax.bar(df["day"], df["tx_count"], width=1.0, color=BAR[name],
           linewidth=0, zorder=1)
    ax.set_ylabel("Tx count", fontsize=7.5)
    ax.margins(x=0.01)
    ax.tick_params(labelsize=7)
    ax.yaxis.get_offset_text().set_fontsize(7)

    ax2 = ax.twinx()
    ax2.plot(df["day"], gas, color=C_GAS, linewidth=1.0, zorder=3,
             label="L1 DA gas (ETH)")
    ax2.plot(df["day"], fee, color=C_FEE, linewidth=1.0, linestyle="--",
             zorder=3, label="L2 fee (ETH)")
    ax2.set_yscale("log")
    ax2.set_ylabel("ETH (log)", fontsize=7.5)
    ax2.tick_params(labelsize=7)

    for x, lab in [(DENCUN, "Dencun"), (PECTRA, "Pectra")]:
        ax.axvline(x, color="#7F7F7F", linewidth=0.8, linestyle=":", zorder=2)
        if k == 0:
            ax.annotate(lab, xy=(x, 1.0), xycoords=("data", "axes fraction"),
                        xytext=(3, -2), textcoords="offset points",
                        fontsize=7, color="#5F5F5F", va="top")

    ax.annotate(f"({chr(97+k)}) {name}", xy=(0.99, 0.96),
                xycoords="axes fraction", fontsize=8.5, va="top", ha="right",
                fontweight="bold")

    for sp in ("top",):
        ax.spines[sp].set_visible(False)
        ax2.spines[sp].set_visible(False)

    if k == 0:
        h, l = ax2.get_legend_handles_labels()
        fig.legend(h, l, loc="upper center", fontsize=7.5, frameon=False,
                   ncol=2, bbox_to_anchor=(0.5, 1.0))

axes[-1].xaxis.set_major_locator(mdates.MonthLocator(interval=3))
axes[-1].xaxis.set_major_formatter(mdates.DateFormatter("%Y-%m"))
plt.setp(axes[-1].get_xticklabels(), rotation=0, fontsize=7)

fig.subplots_adjust(left=0.075, right=0.93, top=0.94, bottom=0.06)
fig.savefig("/home/claude/timeseries.pdf")
fig.savefig("/home/claude/timeseries.png", dpi=140)
print("done")

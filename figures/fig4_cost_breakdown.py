"""Cost structure breakdown figure for Section IV-F.
Data: Tables II, VII, VIII (April 2026, P_ETH = $2,252).
Decomposition: infra = observed_total - DA; storage = SSD_GB * $0.08/GB * nodes;
compute = infra - storage. Node counts recovered as infra / c_node (all integer-consistent).
"""
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np

P = 2252.0
# name, TPS, observed_total, node_usd, ssd_gb_priced, cd_eth, blob_eth, fee_eth
D = [
    ("Morph",        0.07,  5367, 362.24,  1000, 0.277, 0.015,    0.336391),
    ("Facet v1",     0.08,   740, 125.47,    50, 0.217, 0.000,    0.012731),
    ("DeBank Chain", 0.50,   421, 129.47,   100, 0.015, 0.057,    0.001955),
    ("Metal",        0.50,  5362, 285.31,  2000, 0.586, 1.416,    0.015606),
    ("Boba",         0.52,   586, 129.47,   100, 0.030, 0.116,    0.063370),
    ("Zora",         0.55,   709, 133.47,   150, 0.040, 0.097,    0.095616),
    ("Lisk",         0.61,   411, 100.74,   500, 0.010, 0.083,    0.235515),
    ("Taiko",        0.65,  5053, 285.31,  2000, 1.945, 0.047,    3.293900),
    ("Mode Network", 0.88,  1038, 137.47,   200, 0.081, 0.198,    0.120900),
    ("Blast",        2.11,  2506, 129.47,   100, 0.010, 0.988,    0.350225),  # SSD priced as 100 GB (footnote)
    ("Ink",          5.69,  5651, 285.31,  2000, 0.146, 2.112,    4.734000),
    ("Unichain",     8.51,  6899, 161.47,   500, 0.356, 2.567,    2.172400),
    ("OP Mainnet",  19.40, 11989, 203.39,  1000, 0.314, 4.834,   21.810000),
    ("Arbitrum One",23.23, 15752, 970.24,  5000, 2.501, 2.775,  160.210000),
    ("Base",        91.32, 90179, 2737.92, 30000, 3.417, 34.229, 1208.120000),
]

names, tps = [], []
comp, stor, cd, blob, total, rev = [], [], [], [], [], []
for n, t, obs, cnode, gb, c_e, b_e, f_e in D:
    da = (c_e + b_e) * P
    infra = obs - da
    nodes = round(infra / cnode)
    s = gb * 0.08 * nodes
    names.append(n); tps.append(t)
    cd.append(c_e * P); blob.append(b_e * P)
    stor.append(s); comp.append(infra - s)
    total.append(obs); rev.append(f_e * P)

names = names[::-1]; tps = tps[::-1]
comp = np.array(comp[::-1]); stor = np.array(stor[::-1])
cd = np.array(cd[::-1]); blob = np.array(blob[::-1])
total = np.array(total[::-1]); rev = np.array(rev[::-1])

mpl.rcParams.update({
    "font.family": "serif", "font.serif": ["DejaVu Serif"],
    "font.size": 8, "axes.linewidth": 0.6,
    "xtick.major.width": 0.6, "ytick.major.width": 0.6,
})

C_COMP = "#3B6BA5"; C_STOR = "#9DC3E6"; C_CD = "#EFBE8E"; C_BLOB = "#C6522B"
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(7.16, 3.75), sharey=True,
                               gridspec_kw={"width_ratios": [1.15, 1], "wspace": 0.06})
y = np.arange(len(names))
h = 0.62

# --- Panel (a): composition shares ---
tot = comp + stor + cd + blob
sh = [100 * x / tot for x in (comp, stor, cd, blob)]
left = np.zeros(len(names))
for s, c, lab in zip(sh, (C_COMP, C_STOR, C_CD, C_BLOB),
                     (r"Compute  $c_\mathrm{comp}$", r"Storage  $c_\mathrm{stor}$", r"DA calldata  $\alpha_\mathrm{cd}V_\mathrm{cd}$", r"DA blob  $\alpha_\mathrm{blob}V_\mathrm{blob}$")):
    ax1.barh(y, s, h, left=left, color=c, label=lab, edgecolor="white", linewidth=0.4)
    left += s
ax1.set_xlim(0, 100)
ax1.set_yticks(y)
ax1.set_yticklabels([f"{n}  ({t:g} TPS)" for n, t in zip(names, tps)], fontsize=7.5)
ax1.set_xlabel("Share of monthly operational cost (%)")
ax1.set_title("(a) Cost composition by model axis", fontsize=8.5)
ax1.tick_params(axis="y", length=0)
for sp in ("top", "right"):
    ax1.spines[sp].set_visible(False)

# --- Panel (b): absolute cost vs. fee revenue ---
ax2.barh(y, total, h, color="#BFC5CC", edgecolor="none", label=r"Total cost $C_\mathrm{total}$", zorder=2)
ax2.scatter(rev, y, marker="D", s=16, color="#1A1A1A", zorder=3, label="L2 fee revenue")
ax2.set_xscale("log")
ax2.set_xlim(30, 3e6)
ax2.set_xlabel("Monthly USD (log scale)")
ax2.set_title("(b) Cost vs. fee revenue", fontsize=8.5)
ax2.tick_params(axis="y", length=0)
for sp in ("top", "right"):
    ax2.spines[sp].set_visible(False)
ax2.grid(axis="x", which="major", color="#E4E4E4", linewidth=0.5, zorder=0)

handles1, labels1 = ax1.get_legend_handles_labels()
handles2, labels2 = ax2.get_legend_handles_labels()
fig.legend(handles1 + handles2, labels1 + labels2, loc="lower center",
           ncol=3, frameon=False, fontsize=7.5, bbox_to_anchor=(0.5, 0.0),
           handlelength=1.2, columnspacing=1.2)
fig.subplots_adjust(left=0.215, right=0.985, top=0.92, bottom=0.27)
fig.savefig("/home/claude/fig_cost_breakdown_fam.pdf")
fig.savefig("/home/claude/fig_cost_breakdown_fam.png", dpi=200)
print("done")

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# CSV 파일 불러오기
df = pd.read_csv('ORU.csv')

# radar chart 축 (컬럼 이름)
labels = ['Net Profit', 'DA Gas', 'Validator', 'Sequencer', 'L2 Fee']
num_vars = len(labels)

angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
angles += angles[:1]  # polygon close

palette = sns.color_palette("Set1", len(df))

label_colors = {
    'Net Profit': 'red',
    'L2 Fee': 'red',
    'DA Gas': 'blue',
    'Validator': 'blue',
    'Sequencer': 'blue'
}

# 그룹 설정 (원하는 index 그룹)
groups = [
    df.iloc[0:3],                        # U0: DeBank, Optopia, Blast
    df.iloc[np.r_[3, 6:10]],             # U1 적자: Mode, Zora, Boba, Metal, Mint
    df.iloc[np.r_[10, 15, 16]],          # Classified 적자: Morph, Unichain, Facet
    df.iloc[np.r_[4, 5, 11:15]],         # Profit: Lisk, Taiko, Arbitrum, Base, OP, Ink
]

# 그룹별 첫 축 설정 (라벨, 색)
first_axis = [
    ('Net Cost', 'blue'),    # 그룹 0
    ('Net Cost', 'blue'),    # 그룹 1
    ('Net Cost', 'blue'),    # 그룹 2
    ('Net Profit', 'red'),   # 그룹 3
]

for i, group in enumerate(groups):
    fig, ax = plt.subplots(figsize=(7,7), subplot_kw=dict(polar=True))

    ax.set_theta_direction(-1)
    ax.set_theta_offset(np.pi / 2)

    # 이 그룹의 첫 축 라벨/색
    first_label, first_color = first_axis[i]
    cur_labels = [first_label] + labels[1:]
    cur_label_colors = {
        first_label: first_color,
        'L2 Fee': 'red',
        'DA Gas': 'blue',
        'Validator': 'blue',
        'Sequencer': 'blue'
    }

    for j, (index, row) in enumerate(group.iterrows()):
        values = [9.99 if v == 10 else v for v in row[labels].tolist()]
        values += values[:1]
        ax.plot(angles, values, linewidth=2, label=row['Rollup'], color=palette[j])

    ax.set_xticks(angles[:-1])
    ax.set_xticklabels([])
    for angle, label in zip(angles[:-1], cur_labels):
        if label in ('Net Profit', 'Net Cost'):
            ax.text(angle, 10.5, label,
                horizontalalignment='center',
                verticalalignment='center',
                fontsize=17,
                color=cur_label_colors.get(label, 'black'),
                transform=ax.transData)
        else:
            ax.text(angle, 12, label,
                horizontalalignment='center',
                verticalalignment='center',
                fontsize=17,
                color=cur_label_colors.get(label, 'black'),
                transform=ax.transData)

    ax.set_yticklabels([])
    ax.set_ylim(0, 10)

    plt.legend(loc='upper right', bbox_to_anchor=(1.3, 1.1), fontsize=15)

    filename = f"level{i}.pdf"
    plt.savefig(filename, bbox_inches='tight', pad_inches=0)
    plt.close()
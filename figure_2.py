#======================================================================================
# load libraries
#======================================================================================
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

#======================================================================================
# define function to plot a single subplot
#======================================================================================
# Function to plot a single subplot
def plot_subplot(ax, df, custom_labels, xticks, title):
    for i, row in df.iterrows():
        ax.errorbar(x=row['coef'], y=row['var'],
                    xerr=[[row['coef'] - row['ci_lower']], [row['ci_upper'] - row['coef']]],
                    fmt='o', color='black', ecolor='gray', capsize=5, markersize=3)
        ax.text(row['coef'], row['var'], f'{row["coef"]:.3f}{row["significance"]}',
                va='bottom', ha='right' if row['coef'] < 0 else 'left',
                fontsize=14, color='black')
    ax.invert_yaxis()
    ax.set_yticks(df['var'])
    ax.set_yticklabels(custom_labels, fontsize=12)
    ax.axvline(0, color='black', linestyle='--', linewidth=1)
    ax.set_xticks(xticks)
    ax.set_xticklabels(xticks, fontsize=14)
    ax.set_title(title, fontsize=14)

# Create a 2x4 grid of subplots
fig, axes = plt.subplots(2, 4, figsize=(30, 15))
axes = axes.flatten()
fig.subplots_adjust(hspace=0.5, wspace=0.3)  # Adjust spacing between subplots

#======================================================================================
# load data and plot each dataframe in the respective subplot
#======================================================================================
#----------------------------------------------------------
# All Counties
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_all.dta')
df = df[:9]
df
df['var'] = pd.Categorical(df['var'],
    categories=['trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1.5, -1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[0], df, custom_labels, xticks, "All counties")

#----------------------------------------------------------
# Black Protestants
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_bp.dta')
df = df[:10]
df
df['var'] = pd.Categorical(df['var'],
    categories=['pct2020', 'trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Religious population",
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1.5, -1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[1], df, custom_labels, xticks, "Black Protestant")

#----------------------------------------------------------
# Catholics
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_ca.dta')
df = df[:10]
df
df['var'] = pd.Categorical(df['var'],
    categories=['pct2020', 'trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Religious population",
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1, 1.25, 1.5]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[2], df, custom_labels, xticks, "Catholic")

#----------------------------------------------------------
# Evangelical Protestants
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_ep.dta')
df = df[:10]
df
df['var'] = pd.Categorical(df['var'],
    categories=['pct2020', 'trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Religious population",
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[3], df, custom_labels, xticks, "Evangelical Protestant")

#----------------------------------------------------------
# Islam
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_is.dta')
df = df[:10]
df
df['var'] = pd.Categorical(df['var'],
    categories=['pct2020', 'trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Religious population",
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1.5, -1, -0.5, 0, 0.5, 1]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[4], df, custom_labels, xticks, "Islam")

#----------------------------------------------------------
# Mainline Protestant
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_mp.dta')
df = df[:10]
df
df['var'] = pd.Categorical(df['var'],
    categories=['pct2020', 'trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Religious population",
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1.2, -1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[5], df, custom_labels, xticks, "Mainline Protestant")

#----------------------------------------------------------
# Mormons
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_mo.dta')
df = df[:10]
df
df['var'] = pd.Categorical(df['var'],
    categories=['pct2020', 'trump', 'income1000', 'uninsur', 'coll', 'pcthis', 'pctbla', 'pctwhi', 'pctasi', '0.metro'],
    ordered=True)
custom_labels = [
    "% Religious population",
    "% Voting Republican",
    "Income",
    "% Uninsured population",
    "% College graduates",
    "% Hispanic",
    "% Black",
    "% White",
    "% Asian",
    "Non-metro",
]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
# xticks = [-1.2, -1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
xticks = [-4.0, 0, 4.0]
plot_subplot(axes[6], df, custom_labels, xticks, "Mormons")

#----------------------------------------------------------
# Turn off the 8th subplot (bottom-right corner)
#----------------------------------------------------------
axes[7].axis('off')

#----------------------------------------------------------
# save the figure
#----------------------------------------------------------
plt.tight_layout()
plt.savefig('./results/figure_2.png', bbox_inches='tight', dpi=600)


#======================================================================================
# END
#======================================================================================


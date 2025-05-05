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
                fontsize=12, color='black')
    ax.invert_yaxis()
    ax.set_yticks(df['var'])
    ax.set_yticklabels(custom_labels, fontsize=12)
    ax.axvline(0, color='black', linestyle='--', linewidth=1)
    ax.set_xticks(xticks)
    ax.set_xticklabels(xticks, rotation=60, fontsize=12)
    ax.set_title(title, fontsize=14)

# Create a 3x3 grid of subplots
fig, axes = plt.subplots(3, 3, figsize=(18, 18))
fig.subplots_adjust(hspace=0.5, wspace=0.3)  # Adjust spacing between subplots

#======================================================================================
# load data and plot each dataframe in the respective subplot
#======================================================================================
#----------------------------------------------------------
# bp
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_bp.dta')
df = df.drop([4, 5, 9], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1.5, -1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5]
plot_subplot(axes[0, 0], df, custom_labels, xticks, "Black Protestant")

#----------------------------------------------------------
# ca
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_ca.dta')
df = df.drop([4, 5, 9], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1, 1.25, 1.5]
plot_subplot(axes[0, 1], df, custom_labels, xticks, "Catholic")

#----------------------------------------------------------
# ep
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_ep.dta')
df = df.drop([4, 5, 9], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
plot_subplot(axes[0, 2], df, custom_labels, xticks, "Evangelical Protestant")

#----------------------------------------------------------
# is
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_is.dta')
df = df.drop([4, 5, 9], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1.5, -1, -0.5, 0, 0.5, 1]
plot_subplot(axes[1, 0], df, custom_labels, xticks, "Islam")

#----------------------------------------------------------
# mp
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_mp.dta')
df = df.drop([4, 5, 9], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1.2, -1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
plot_subplot(axes[1, 1], df, custom_labels, xticks, "Mainline Protestant")

#----------------------------------------------------------
# mo
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_mo.dta')
df = df.drop([4, 5, 9], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1.2, -1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
plot_subplot(axes[1, 2], df, custom_labels, xticks, "Mormons")

#----------------------------------------------------------
# bp_urban
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_bpu.dta')
df = df.drop([3, 4, 8], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1.5, -1.25, -1, -0.75, -0.5, -0.25, 0, 0.25, 0.5]
plot_subplot(axes[2, 0], df, custom_labels, xticks, "Black Protestant-Urban")

#----------------------------------------------------------
# bp_south
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_bps.dta')
df = df.drop([4, 5], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '0.metro'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Non-metro"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4]
plot_subplot(axes[2, 1], df, custom_labels, xticks, "Black Protestant-South")

#----------------------------------------------------------
# is_urban
#----------------------------------------------------------
df = pd.read_stata('./data/reg_results_isu.dta')
df = df.drop([3, 4, 8], axis=0)
df['var'] = pd.Categorical(df['var'],
                           categories=['pct2020', 'trump', 'income1000', '2.region', '3.region', '4.region'],
                           ordered=True)
custom_labels = ["% Religious population", "% Voting Republican", "Income", "Midwest", "West", "South"]
df['significance'] = ''
df.loc[df['pval'] < 0.05, 'significance'] = '*'  # * for p < 0.05
df.loc[df['pval'] < 0.01, 'significance'] = '**'  # ** for p < 0.01
df.loc[df['pval'] < 0.001, 'significance'] = '***'  # *** for p < 0.001
xticks = [-3, -2.5, -2, -1.5, -1, -0.5, 0, 0.5, 1]
plot_subplot(axes[2, 2], df, custom_labels, xticks, "Islam-Urban")

#----------------------------------------------------------
# save the figure
#----------------------------------------------------------
plt.tight_layout()
plt.savefig('./results/reg_coefplot.png', bbox_inches='tight', dpi=600)



#======================================================================================
# END
#======================================================================================


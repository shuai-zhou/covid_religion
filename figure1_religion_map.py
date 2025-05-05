#======================================================================================
# load libraries
#======================================================================================
import os
import numpy as np
import pandas as pd
import seaborn as sns
import geopandas as gpd
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
from matplotlib.colors import ListedColormap
from mapclassify import Quantiles, UserDefined

#======================================================================================
# read data
#======================================================================================
states = gpd.read_file('./data/states_2163.zip')

cus = gpd.read_file('./data/cus_2163.zip')
cus.shape
cus.head()

df = pd.read_stata('./data/resdata_religion_map.dta')
df.shape
df.head()

gdf = cus.merge(df, on='countyfips')
gdf.shape
gdf.head()

bs10 = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
la10 = ['0-10', '10-20', '20-30', '30-40', '40-50', '50-60', '60-70', '70-80', '80-90', '90-100']

bs5 = [0, 20, 40, 60, 80, 100]
la5 = ['0%–20%', '20%–40%', '40%–60%', '60%–80%', '80%–100%']

gdf['cat_bp'] = pd.cut(gdf['pct_bp'], bins=bs5, labels=la5, include_lowest=True)
gdf['cat_ca'] = pd.cut(gdf['pct_ca'], bins=bs5, labels=la5, include_lowest=True)
gdf['cat_ep'] = pd.cut(gdf['pct_ep'], bins=bs5, labels=la5, include_lowest=True)
gdf['cat_is'] = pd.cut(gdf['pct_is'], bins=bs5, labels=la5, include_lowest=True)
gdf['cat_mp'] = pd.cut(gdf['pct_mp'], bins=bs5, labels=la5, include_lowest=True)
gdf['cat_mo'] = pd.cut(gdf['pct_mo'], bins=bs5, labels=la5, include_lowest=True)

#======================================================================================
# plot religion in grey
#======================================================================================
fig, ((ax1, ax2, ax3), (ax4, ax5, ax6)) = plt.subplots(2, 3, figsize=(15, 6))
cmap = ListedColormap(["#f5f5f5", "#cccccc", "#999999", "#666666", "#333333"])

gdf.plot(ax=ax1, column='cat_bp', cmap=cmap, categorical=True, missing_kwds={'color':'white'})
gdf.plot(ax=ax2, column='cat_ca', cmap=cmap, categorical=True, missing_kwds={'color':'white'})
gdf.plot(ax=ax3, column='cat_ep', cmap=cmap, categorical=True, missing_kwds={'color':'white'})
gdf.plot(ax=ax4, column='cat_is', cmap=cmap, categorical=True, missing_kwds={'color':'white'})
gdf.plot(ax=ax5, column='cat_mp', cmap=cmap, categorical=True, missing_kwds={'color':'white'})
gdf.plot(ax=ax6, column='cat_mo', cmap=cmap, categorical=True, missing_kwds={'color':'white'})

states.boundary.plot(ax=ax1, facecolor='none', edgecolor='black', lw=0.5)
states.boundary.plot(ax=ax2, facecolor='none', edgecolor='black', lw=0.5)
states.boundary.plot(ax=ax3, facecolor='none', edgecolor='black', lw=0.5)
states.boundary.plot(ax=ax4, facecolor='none', edgecolor='black', lw=0.5)
states.boundary.plot(ax=ax5, facecolor='none', edgecolor='black', lw=0.5)
states.boundary.plot(ax=ax6, facecolor='none', edgecolor='black', lw=0.5)

leg = [Line2D([0],[0], color='#f5f5f5', lw=20,),
       Line2D([0],[0], color='#cccccc', lw=20),
       Line2D([0],[0], color='#999999', lw=20),
       Line2D([0],[0], color='#666666', lw=20),
       Line2D([0],[0], color='#333333', lw=20)]
fig.legend(leg, ['0%–20%', '20%–40%', '40%–60%', '60%–80%', '80%–100%', 'Missing values'],
           loc='center', fontsize=12, frameon=False, ncol=6, bbox_to_anchor=(0.50, 0.05))

ax1.axis('off')
ax1.set_title('Black Protestant', loc='left', fontsize=12)
ax2.axis('off')
ax2.set_title('Catholic', loc='left', fontsize=12)
ax3.axis('off')
ax3.set_title('Evangelical Protestant', loc='left', fontsize=12)
ax4.axis('off')
ax4.set_title('Islam', loc='left', fontsize=12)
ax5.axis('off')
ax5.set_title('Mainline Protestant', loc='left', fontsize=12)
ax6.axis('off')
ax6.set_title('Mormons', loc='left', fontsize=12)

fig.savefig('./results/religion_map_grey.png', bbox_inches='tight', dpi=300)

#======================================================================================
# END
#======================================================================================


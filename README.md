Here’s your **ready-to-paste single-file `README.md`** — formatted exactly like your sample (minimal separators, emojis, and color via badges). It keeps everything concise and well-structured for GitHub rendering.


---

## 🌍 Project Summary

> 🧠 **Goal:** To explore molecular signatures of chronic non-healing wounds by identifying **differentially expressed genes**, **protein–protein interaction (PPI) networks**, and **ligand–receptor signaling pairs** in diabetic foot ulcer (DFU) vs. diabetic foot skin (DFS) samples.

This project transforms transcriptomic data from **GEO: GSE134431** into biological networks to discover:
- Key **hub genes** and **modules** enriched in wound-healing pathways.  
- Potential **ligand–receptor (LR) interactions** driving impaired healing.  
- Pathway-level insights through **Reactome enrichment**.

All analyses are modularized into R scripts and reproducible end-to-end on an HPC system.

---

## Narrative
🩸 Diabetic Foot Ulcer (DFU) Transcriptomic Network Analysis explores the molecular signatures of chronic, non-healing wounds in diabetes by integrating transcriptomics, network biology, and ligand–receptor signaling. Using RNA-seq data from GEO: GSE134431, the project compares diabetic foot ulcer (DFU) tissue with diabetic foot skin (DFS) to identify the genetic and signaling imbalances that prevent proper tissue regeneration.

🧬 After filtering for high-confidence genes (q < 0.05, |FC| > 1.5), DFU samples showed a clear upregulation of immune response, inflammatory cytokines, and matrix degradation enzymes, reflecting a persistently inflamed and fibrotic microenvironment.

🔗 To capture system-level interactions, a protein–protein interaction (PPI) network was built using STRING v12, focusing on high-confidence edges (score ≥ 700). Louvain clustering revealed distinct modules associated with cytokine signaling, angiogenesis, keratinocyte migration, and cell adhesion. Central hub genes such as CXCL8, IL1B, MMP9, and COL1A1 emerged as key regulators, underscoring an imbalance between inflammation and matrix remodeling in DFUs.

🧠 Next, ligand–receptor (LR) mapping via OmnipathR identified potential intercellular signaling axes within the ulcer microenvironment. Highly ranked LR pairs ; including IL1B–IL1R1, CXCL8–CXCR2, and TGFB1–TGFBR2 — scored strongly for both network centrality and dysregulation, highlighting persistent inflammatory crosstalk and impaired regenerative signaling.

💥 Reactome enrichment analyses reinforced these findings, showing module-level enrichment in neutrophil degranulation, ECM organization, and integrin-mediated signaling, all central to wound persistence and delayed closure.

🧫 Altogether, the project depicts DFUs as biologically “stuck” wounds — trapped between chronic inflammation and incomplete repair. By combining differential expression, network topology, and ligand–receptor communication, this work outlines a computational roadmap for identifying therapeutically actionable hubs in wound-healing biology. The insights suggest that cytokine modulation and matrix-stabilizing interventions could help rebalance the wound environment toward proper healing.

---

## 🧩 Workflow Overview

```mermaid
flowchart LR
  A[Raw FASTQ from GEO: GSE134431] --> B[Salmon / STAR Quantification]
  B --> C[ANOVA Differential Expression DFU vs DFS]
  C --> D[Filter DEGs (q < 0.05, |FC| > 1.5)]
  D --> E[biomaRt ID Mapping]
  E --> F[STRING PPI Network (score ≥ 700)]
  F --> G[Louvain Clustering & Hub Detection]
  G --> H[Reactome Enrichment (msigdbr + fgsea)]
  G --> I[Omnipath Ligand–Receptor Pairs]
  I --> J[Rank LR Pairs by Network + Dysregulation]
  J --> K[Interactive visNetwork Visualization + Reports]
````

---

## 🧬 Data Details

**🧾 Source Dataset**

* **GEO Accession:** [GSE134431](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE134431)
* **Organism:** *Homo sapiens*
* **Tissue:** Diabetic foot skin (DFS) and diabetic foot ulcer (DFU) biopsies
* **Study Design:** RNA-seq, paired-end Illumina sequencing

---

## 📦 Raw FASTQ Access

```bash
# Load SRA Toolkit on HPC
module load sratoolkit

# Create folder
mkdir -p fastq

# Download and convert
prefetch SRRXXXXXXX
fasterq-dump SRRXXXXXXX --split-files -O fastq/ --threads 8
gzip fastq/*.fastq
```

---

## 🧠 Analysis Summary

| Step                           | Description                                       | Tools / Packages            |        |         |
| ------------------------------ | ------------------------------------------------- | --------------------------- | ------ | ------- |
| **1. Differential Expression** | ANOVA (DFU vs DFS)                                | `readxl`, `dplyr`           |        |         |
| **2. DEG Filtering**           | `q < 0.05`, `                                     | FC                          | > 1.5` | `dplyr` |
| **3. ID Mapping**              | HGNC → Ensembl / UniProt                          | `biomaRt`                   |        |         |
| **4. PPI Network**             | STRING v12, score ≥ 700                           | `STRINGdb`, `igraph`        |        |         |
| **5. Community Detection**     | Louvain clustering + hub centrality               | `igraph`                    |        |         |
| **6. Reactome Enrichment**     | Pathway enrichment per module                     | `msigdbr`, `fgsea`          |        |         |
| **7. Ligand–Receptor Pairs**   | From Omnipath + ranking by degree + dysregulation | `OmnipathR`, `dplyr`        |        |         |
| **8. Visualization**           | Interactive network graphs                        | `visNetwork`, `htmlwidgets` |        |         |

---

## 🚀 How to Run

Run everything in one go:

```r
source("DFU/analysis/run_all.R")
```

Or run specific modules (e.g., network only):

```r
source("DFU/analysis/04_string_network.R")
```

Outputs are stored in `DFU/results/`.

---

## 📊 Outputs

| File                             | Description                             |
| -------------------------------- | --------------------------------------- |
| `dfu_network_topHubs.html`       | Interactive STRING hub network          |
| `dfu_modules_reactome_top10.csv` | Top Reactome terms per module           |
| `dfu_ligrec_ranked.csv`          | All ligand–receptor pairs ranked        |
| `dfu_top10_LR_network.html`      | Interactive LR visualization            |
| `dfu_top10_LR_report.csv`        | Top 10 actionable ligand–receptor pairs |

---

## ⚙️ Parameters

| Parameter          | Description                          | Default        |
| ------------------ | ------------------------------------ | -------------- |
| `MIN_STRING_SCORE` | Minimum STRING confidence            | 700            |
| `TOP_N_HUBS`       | Nodes displayed in hub visualization | 100            |
| `STRICT_SCORE`     | Score filter for exports             | 850            |
| `RESULTS_DIR`      | Output directory                     | `DFU/results/` |


---

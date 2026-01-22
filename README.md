1. Deixar somente pseudo-cromossomos (25 scaffolds maiores)
2. Rodar minimap: run_minimap.sh
3. Rodar bcftools (VM unicamp)
   ```
   bcftools mpileup -C50 -Ou -f PITSTA_inv_final_chroms.fasta PITSTA_inv_final_chroms_PacBio.bam --threads 20 | bcftools call -c -Ob -o PITSTA_inv_final_PSMC.bcf
   ```
   ```
   bcftools mpileup -C50 -Ou -f PITALB_final_invcorrected_chroms.fasta PITALB_final_invcorrected_chroms.fasta_PacBio.bam --threads 20 | bcftools call -c -Ob -o PITALB_final_invcorrected_PSMC.bcf
   ```
5.  Saber cobertura

_P. albiflos_:**47.37x**

_P. staminea_:**50.23x**

7. Indexar
```
bcftools index *.bcf
```

9. Transformar .bcf em .fasta. Com dados de cobertura (muito importante para PSMC)
 
_P. staminea_
```
bcftools consensus -f PITSTA_inv_final_chroms.fasta -m <(bcftools view -i 'DP<17 || DP>100 || QUAL<30' PITSTA_inv_final_PSMC.bcf) PITSTA_inv_final_PSMC.bcf > PITSTA.psmc.fasta

bcftools consensus -f PITSTA_inv_final_chroms.fasta -m <(bcftools view -i 'DP<16 || DP>95 || QUAL<30' PITSTA_inv_final_PSMC.bcf) PITSTA_inv_final_PSMC.bcf > PITSTA1.psmc.fasta
```   
_P. albiflos_   
```
bcftools consensus -f PITALB_final_invcorrected_chroms.fasta -m <(bcftools view -i 'DP<16 || DP>95 || QUAL<30' PITALB_final_invcorrected_PSMC.bcf) PITALB_final_invcorrected_PSMC.bcf > PITALB.psmc.fasta
```

10. RODAR PSMC de fato
```
conda activate psmc
```
_P.albiflos_
```
fq2psmcfa -q20 PITALB.psmc.fasta > PITALB.psmcfa
splitfa PITALB.psmcfa > split.PITALB.psmcfa
psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o PITALB.psmc PITALB.psmcfa
	seq 100 | xargs -i echo psmc -N25 -t15 -r5 -b -p "4+25*2+4+6" \
	    -o round-{}.psmc split.PITALB.psmcfa | sh
    cat PITALB.psmc round-*.psmc > combined.PITALB.psmc
psmc_plot.pl -u 3e-9 -g 5 -R -p combined combined.PITALB.psmc
```
_P. staminea_
```
fq2psmcfa -q20 PITSTA.psmc.fasta > PITSTA.psmcfa
splitfa PITSTA.psmcfa > split.PITSTA.psmcfa
psmc -N25 -t15 -r5 -p "20+10" -o PITSTA.psmc PITSTA.psmcfa
	seq 100 | xargs -i echo psmc -N25 -t15 -r5 -b -p "4+25*2+4+6" \
	    -o round-{}.psmc split.fa | sh
    cat PITSTA.psmc round-*.psmc > combined.PITSTA.psmc
psmc_plot.pl -u 3e-9 -g 5 -R -pY50000 combined combined.PITSTA.psmc
```
















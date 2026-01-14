1. Deixar somente pseudo-cromossomos (25 scaffolds maiores)
2. Rodar minimap: run_minimap.sh
3. Rodar bcftools (VM unicamp)
   ```
   bcftools mpileup -C50 -Ou -f PITSTA_inv_final_chroms.fasta PITSTA_inv_final_chroms_PacBio.bam --threads 20 | bcftools call -c - > PITSTA_inv_final_PSMC.bcf

   mv PITSTA_inv_final_PSMC.bcf PITSTA_inv_final_PSMC.vcf

   bcftools view -Ob PITSTA_inv_final_PSMC.vcf -o PITSTA_inv_final_PSMC.bcf
   ```
   ```
   bcftools mpileup -C50 -Ou -f PITALB_final_invcorrected_chroms.fasta PITALB_final_invcorrected_chroms.fasta_PacBio.bam --threads 20 | bcftools call -c - > PITALB_final_invcorrected_PSMC.bcf

   mv PITALB_final_invcorrected_PSMC.bcf PITALB_final_invcorrected_PSMC.vcf

   bcftools view -Ob PITALB_final_invcorrected_PSMC.vcf -o PITALB_final_invcorrected_PSMC.bcf
   ```
5.  Saber cobertura

_P. albiflos_:**47.37x**

_P. staminea_:**50.23x**

7. Indexar
```
bcftools index
```

9. Transformar .bcf em .fasta. Com dados de cobertura (muito importante para PSMC)
 
_P. staminea_
```
bcftools consensus -f PITSTA_inv_final_chroms.fasta \
  -m <(bcftools view -i 'DP<17 || DP>100 || QUAL<30' PITSTA_inv_final_PSMC.bcf) \
  PITSTA_inv_final_PSMC.bcf > PITSTA.psmc.fasta
```   
_P. albiflos_   
```
bcftools consensus -f PITALB_final_invcorrected_chroms.fasta \
  -m <(bcftools view -i 'DP<16 || DP>95 || QUAL<30' PITALB_final_invcorrected_PSMC.bcf) \
  PITALB_final_invcorrected_PSMC.bcf > PITALB.psmc.fasta
```


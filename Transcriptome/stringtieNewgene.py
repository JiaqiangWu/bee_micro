import sys
import os

#Usage:Quantification based on transcriptome assembly
#Example:python stringtieNewgene.py ~/Hisat
#        python stringtieNewgene.py <Bam file after alighment>

#save sample files in dictionary format
os.chdir(sys.argv[1])
bam = os.listdir(sys.argv[1])
sample = {}
for f in bam:
    if f.endswith('.bam'):
        name_all = f.split('.')[0]
        name = name_all.split('_')[0]
        if name not in sample:
            sample[name] = []
        sample[name].append(os.path.abspath(f))
        sample[name].append(name_all+'.gtf')

#get reference genome in gtf format
os.chdir('../data/ref')
ref = os.listdir('./')
ref_gtf = os.path.abspath(ref[2])

os.chdir('../../')
if not(os.path.isdir('new_HisatStringtie')):
    os.mkdir('new_HisatStringtie')
os.chdir('./new_HisatStringtie')

#write the sample to be merged into a file
m = open('mergelist.txt','w+')
for k in sample:
    m.write(sample[k][1]+'\n')
m.close()
m = os.path.abspath('mergelist.txt')

#initially assembly of each sample
for k in sample:
    os.system('stringtie -p 8 -G %s -o %s %s'%(ref_gtf,sample[k][1],sample[k][0]))

#merge assemble transcripts
os.system('stringtie --merge -p 8 -G %s -o stringtie_merged.gtf %s'%(ref_gtf,m))
merge = os.path.abspath('stringtie_merged.gtf')

#compare the merged gtf with the reference gtf
if not(os.path.isdir('merge')):
    os.mkdir('merge')
os.chdir('./merge')
os.system('gffcompare -r %s -G -o merged %s'%(ref_gtf,merge))

#Quantification based on 'stringtie.merged.gtf'
os.chdir('../')
for k in sample:
    os.system('stringtie -e -B -p 8 -G '+merge+' -o '+'ballgown/'+k+'/'+sample[k][1]+' '+sample[k][0])

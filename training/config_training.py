config = {'stage1_data_path':'/datadrive/lung_cancer/lung_cancer_dsb/stage1/',
          'luna_raw':'/datadrive/lung_cancer/luna/',
          'luna_segment':'/datadrive/lung_cancer/luna/seg-lungs-LUNA16/',
          
          'luna_data':'/datadrive/lung_cancer/sol1/allset/',
          'preprocess_result_path':'/datadrive/lung_cancer/sol1/stage1/preprocess/',       
          
          'luna_abbr':'./detector/labels/shorter.csv',
          'luna_label':'./detector/labels/lunaqualified.csv',
          'stage1_annos_path':['./detector/labels/label_job5.csv',
                './detector/labels/label_job4_2.csv',
                './detector/labels/label_job4_1.csv',
                './detector/labels/label_job0.csv',
                './detector/labels/label_qualified.csv'],
          'bbox_path':'../detector/results/res18/bbox/',
          'preprocessing_backend':'python'
         }

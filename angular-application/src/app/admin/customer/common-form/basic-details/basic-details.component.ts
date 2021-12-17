import { Component, Input, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-basic-details',
  templateUrl: './basic-details.component.html',
  styleUrls: ['./basic-details.component.css']
})
export class BasicDetailsComponent implements OnInit {

  @Input() customerDetailsForm: any;

  district: string = '';
  allDistrictList: any = [];
  constructor(private toastr: ToastrService, private service: CommonService) { 
    this.loadDistrictList();
  }

  ngOnInit(): void {
  }


  
  PANpageDiv = false;
  GSTNpageDiv = false;

 
  



  showPANDiv = () => {
    this.PANpageDiv = true;
  }

    hidePANDiv = () => {
    this.PANpageDiv = false;
  }

    showGSTNDiv = () => {
    this.GSTNpageDiv = true;
  }

    hideGSTNDiv = () => {
    this.GSTNpageDiv = false;
  }

  loadDistrictList = async () => {
    try {
        this.allDistrictList = await this.service.get('/getDistrictList');
    } catch (e) {
        this.toastr.error(`Network problem`)
    }
  }
  addDistrict = () => {
    console.log('Calleddd');
    
    if (this.district) {
        const dist: any = this.district;
        if(dist == 'ALL') {
            this.DistrictList.value = []
            this.allDistrictList.forEach((e: any) => {
                this.DistrictList.value.push(e);
            })
        }
        else{
            const distIDs = this.DistrictList.value.map((e: any) => e.dist_id);
            if (distIDs.includes(dist.dist_id)) {
                this.toastr.warning('District Already Added');
            } else {
                this.DistrictList.value.push(dist);
            }
            this.district = '';
        }
    } else {
        this.toastr.error('Please select District first');
    }

  }
  removeDistrict = (index: number) => {
    this.DistrictList.value.splice(index, 1);
  }



  get DistrictList() {
    return this.customerDetailsForm.get('DistrictList');
  }






}

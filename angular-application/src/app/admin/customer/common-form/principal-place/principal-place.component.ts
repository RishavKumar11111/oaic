import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-principal-place',
  templateUrl: './principal-place.component.html',
  styleUrls: ['./principal-place.component.css']
})
export class PrincipalPlaceComponent implements OnInit {

  @Input() customerDetailsForm: any;

  constructor(
    private service: CommonService,
    private fb: FormBuilder,
    private toastr: ToastrService
  ) { 

  this.loadDistrictList();
  this.loadStateList();
  


  this.PrincipalPlaceForm = this.fb.group({
      Country: ['', [Validators.required]],
      StateCode: ['', [Validators.required]],
      DistrictOrCity: ['', [Validators.required]],
      Pincode: ['', [Validators.required]],
      Address: ['', [Validators.required]],

  });

  }

  ngOnInit(): void {
  }



  PrincipalPlaceForm: FormGroup

  authorisedSignatory: any ={};
  principalPlace: any = {Country: 'India'};
  stateList: any = [];
  districtList: any = [];

  loadDistrictList = async () => {
    try{
      this.districtList = await this.service.get('/getDistrictList');
    } catch (e) {
      this.toastr.error(`Network problem`)
    }
  }
  loadStateList = async () => {
    try{
      this.stateList = await this.service.get('/getStateList');
    } catch (e) {
      this.toastr.error(`Network problem`)
    }
  }



  addPrincipalPlace = () => {
    this.customerDetailsForm.value.PrincipalPlaceList.push(this.PrincipalPlaceForm.value);
    this.PrincipalPlaceForm.reset();
  }
  removePrincipalPlace = (index: number) => {
      this.principalPlacesList.splice(index, 1);
  }
  modifyPrincipalPlace = (index: number, x: any) => {
      this.principalPlacesList.splice(index, 1);
      this.principalPlace = x;
  }
 





  get principalPlacesList() {
    return this.customerDetailsForm.get('PrincipalPlaceList').value;
  }




}

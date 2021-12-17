import { Component, Input, OnInit } from '@angular/core';
import { CommonService } from 'src/app/services/common.service';


@Component({
  selector: 'app-enter-item-details-form',
  templateUrl: './enter-item-details-form.component.html',
  styleUrls: ['./enter-item-details-form.component.css']
})
export class EnterItemDetailsFormComponent implements OnInit {

  @Input() ItemDetailsForm: any;
  isNewImplement:boolean = false;
  isNewMake:boolean = false;
  divisionList: any = [];
  impList: any = [];
  makeList: any = [];

  constructor(
    private service: CommonService,
  ) { 
    this.loadDivisionList();
  }

  ngOnInit(): void {
    this.DivisionID.valueChanges.subscribe((x: any) => {
          this.loadImplementList();
    })
    
  }


  loadDivisionList = async () => {
      try{
          this.divisionList = await this.service.get('/admin/getDivisionList');
          if(this.DivisionID.value) {
            this.loadImplementList();
          }
      } catch(e) {
          console.error(e);
      }
  }


  loadImplementList = async() => {
      const response = await this.service.get(`/admin/getAllImplementsForAddItem?DivisionID=${this.DivisionID.value}`);
      this.impList = response.map((e: any) => e.Implement);
      this.impList.push("ADD NEW");
      if(this.Implement.value) {
        this.loadAvlMakes();
      }
  }
  loadAvlMakes = async() => {
      if(this.Implement.value == 'ADD NEW') {
        this.Implement.setValue('');
        this.isNewImplement = true;
        this.isNewMake = true;
      } else {
          const data = { Implement: this.Implement.value, DivisionID: this.DivisionID.value }
          const response = await this.service.post(`/admin/getAvlMakesForAddItem`, data);
          this.makeList = response.map((e: any) => e.Make);          
          if (this.makeList.length == 1) {
              this.Make.setValue(this.makeList[0]);
          }
          this.makeList.push("ADD NEW")
      }
  }
  changeMake() {
      if(this.Make.value == 'ADD NEW') {
        this.isNewMake = true;
        this.Make.setValue('');
      }
  }
  undoToImplementDropDown() {
    this.isNewImplement = false;
    this.isNewMake = false;
    this.Implement.setValue('');
  }
  undoToMakeDropDown() {
    this.isNewMake = false;
    this.Make.setValue('');
  }




  get Implement() {
    return this.ItemDetailsForm.get('Implement')
  }
  get Make() {
    return this.ItemDetailsForm.get('Make')
  }
  get Model() {
    return this.ItemDetailsForm.get('Model')
  }
  get DivisionID() {
    return this.ItemDetailsForm.get('DivisionID')
  }
  get HSN() {
    return this.ItemDetailsForm.get('HSN')
  }
  get UnitOfMeasurement() {
    return this.ItemDetailsForm.get('UnitOfMeasurement')
  }
  get Taxability() {
    return this.ItemDetailsForm.get('Taxability')
  }
  get TaxRate() {
    return this.ItemDetailsForm.get('TaxRate')
  }




}

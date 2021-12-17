import { FormControl } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-re-print',
  templateUrl: './re-print.component.html',
  styleUrls: ['./re-print.component.css']
})
export class RePrintComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Purchase Order / Re-Print P.O.');
  }
  ngOnInit(): void {
  }


  indentsTable: boolean = false;
  printIndent: boolean = false;
  loadingData: boolean = false;
  first_box: boolean = true;
  fin_year: string = '';
  acc_name: string = '';
  paidListData: any;
  fromDate: string = '';
  toDate: string = '';
  search_indent_no: string = ''
  search_dealer_name: string = ''



  PODetails: any = {};
  PONo: FormControl = new FormControl('');

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadManf();
  }
  loadManf = async () => {
      this.loadingData = true;
      const response = await this.service.get('/accountant/getAllGeneratedIndents?fin_year=' + this.fin_year)
              this.printIndent = false;
              this.indentsTable = true;
              this.paidListData = response;
              this.loadingData = false;
  }
  showDetails = async (PONo: any) => {
      this.indentsTable = false;
      this.loadingData = true;
      this.PONo.setValue(PONo);

      const response = await this.service.get('/api/getPODetails?PONumber=' + PONo);
      this.PODetails = response;
      this.loadingData = false;
      this.first_box = false;
      this.printIndent = true;
  }
  back = () => {
      this.indentsTable = true;
      this.printIndent = false;
      this.first_box = true;
  }

}

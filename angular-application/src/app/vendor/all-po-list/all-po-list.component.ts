import { FormControl } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { CommonService } from 'src/app/services/common.service';


@Component({
  selector: 'app-all-po-list',
  templateUrl: './all-po-list.component.html',
  styleUrls: ['./all-po-list.component.css']
})
export class AllPoListComponent implements OnInit {
    
    selectedPONo: string = '';

  constructor(
          private layoutService: LayoutService,
          private service: CommonService
  ) { 
          this.layoutService.setBreadcrumb('All Purchase Orders List');
          this.loadDists();
  }

  ngOnInit(): void {
  }






  show_indent_list = false;
  show_single_indent = false;
  loader = false;
  first_card = true;
  fin_year = '';
  show_print_page : boolean = false;
  dist: any = '';
  indent_list: any = [];
  districts: any = [];
  searchPONo: string = '';
  matchByIndentNo: string = '';

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadAllIndents();
  }

  loadDists = async () => {
      this.show_print_page = false;
      this.districts = await this.service.get(`/dl/getDealerDists`);
  }
  loadAllIndents = async () => {
      this.show_indent_list = false;
      this.loader = true;
      this.indent_list = await this.service.get(`/dl/getAllDistIndent?fin_year=${this.fin_year}`);
      this.show_indent_list = true;
      this.loader = false;
  }
  PONo: FormControl = new FormControl('');
  PODetails: any = {};
  viewIndent = async (x: any) => {
        this.selectedPONo = x.PONo;
      this.show_indent_list = false;

      this.PONo.setValue(x.PONo);

      const response = await this.service.get('/api/getPODetails?PONumber=' + x.PONo);
      this.PODetails = response;
      this.show_single_indent = true;
      this.first_card = false;
  }
  printSingleIndent = () => {
      // printElem('printIndent');
  }
  printAllIndentList = () => {
      // printElem('printAllIndentList');
  }
  back = () => {
      this.show_single_indent = false;
      this.show_indent_list = true;
      this.first_card = true;
  }






}

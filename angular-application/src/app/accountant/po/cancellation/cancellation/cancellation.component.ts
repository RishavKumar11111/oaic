import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-cancellation',
  templateUrl: './cancellation.component.html',
  styleUrls: ['./cancellation.component.css']
})
export class CancellationComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Purchase Order / Cancellation of P.O.');
  }
  ngOnInit(): void {
  }




    indentsTable: boolean = false;
    loadingData: boolean = false;
    first_box: boolean = true;
    fin_year: string = '';
    acc_name: any;
    paidListData: any = [];
    indent: any = {};
    search_indent_no: string = '';
    search_dealer_name: string = '';

    changeFinancialYear(financialYear: string) {
      this.fin_year = financialYear;
      this.loadManf();
    }
    loadAccDetails = async () => {
        const response = await this.service.get('/accountant/getAccName');
        this.acc_name = response.acc_name;
    }
    loadManf = async () => {
        this.loadingData = true;
        this.paidListData = await this.service.get(`/accountant/getAllGeneratedIndents?fin_year=${this.fin_year}`);
        this.indentsTable = true;
        this.loadingData = false;
    }
    selectIndent = (x: any) => {
        this.indent = x;
    }
    cancelIndent = async () => {
        try{
          this.indentsTable = false;
          this.loadingData = true;
          const data = { indent_no: this.indent.indent_no, indent_items: this.indent.items }
          let response = await this.service.post(`/accountant/cancelIndent`, data);
          this.loadingData = false;
          if (response == true) {
                    this.toastr.success('Indent Cancelled Successfully.');
                    this.loadManf();
          } else {
                    this.toastr.error('Invoice is already generated against this Indent. So it cancellation is not possible.');
                    this.indentsTable = true;
          }
        } catch(e) {
            this.toastr.error('Invoice is already generated against this Indent. So it cancellation is not possible.');
            this.indentsTable = true;
            this.loadingData = false;
        }        
    }






}

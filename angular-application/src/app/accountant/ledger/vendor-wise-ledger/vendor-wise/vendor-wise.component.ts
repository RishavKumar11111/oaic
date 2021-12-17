import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-vendor-wise',
  templateUrl: './vendor-wise.component.html',
  styleUrls: ['./vendor-wise.component.css']
})
export class VendorWiseComponent implements OnInit {
  dist_id: any;
  fin_year: any;
  header: any;
  showTable:any = false;
  loader:any =true;
  ledgers: any = [];
  totalCredit: any;
  totalDebit: any;
  all_delears: any = [];
  dealer: any;
  dl_name: any;
  orderBy: any;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
    ) {
      this.layoutService.setBreadcrumb('Ledger / Vendor wise ledger');
      this.dist_id = layoutService.getDistrictID();
     }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadDistWiseAllDealerLedger();
    this.loadDelears();
    this.header = true;
  }

 
   loadDistWiseAllDealerLedger = async() => {
       let response = await this.service.get('/accountant/getDistWiseAllDealerLedger?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year)
            
                this.ledgers = response;
                let data = response;
                this.totalCredit = 0;
                this.totalDebit = 0;
                data.filter((e: any) => e.date = new Date(e.date));
                data.sort((a: any, b: any) => a.date - b.date);
                for (let i = 0; i < data.length; i++) {

                    data[i].debit = 0;
                    data[i].credit = 0;

                    if (data[i].from == 'DS-' + this.dist_id) {
                        data[i].credit = data[i].ammount;
                        data[i].debit = 0;
                        this.totalCredit += parseInt(data[i].credit);
                    } else if (data[i].to == 'DS-' + this.dist_id) {
                        data[i].debit = data[i].ammount;
                        data[i].credit = 0;
                        this.totalDebit += parseInt(data[i].debit);
                    }

                    if (i == 0) {
                        data[i].balance = parseInt(data[i].credit) - parseInt(data[i].debit);
                    } else {
                        data[i].balance = (parseInt(data[i - 1].balance) + parseInt(data[i].credit)) - parseInt(data[i].debit);
                    }
                }
                this.loader = false;
                this.showTable = true;
          
    }
    
    loadDelears = async() => {
        this.showTable = false;
        this.loader = true;
        let response = await this.service.get('/accountant/getAllDistWiseDelear?fin_year=' + this.fin_year + '&dist_id=' + this.dist_id)
            
          this.all_delears = response;
          this.loader = false;
    };
    

    loadTable = async() => {
        this.loader = true;
        if (this.dealer != null) {
           let response = await this.service.get('/accountant/getAllDelearLedgers?dist_id=' + this.dist_id + '&fin_year=' + this.fin_year + '&dl_id=' + this.dealer.dl_id)
                
                    this.dl_name = this.dealer.LegalBussinessName;
                    this.ledgers = response;
                    let data = response;
                    this.totalCredit = 0;
                    this.totalDebit = 0;
                    data.filter((e: any) => e.date = new Date(e.date));
                    data.sort((a: any, b: any) => a.date - b.date);
                    for (let i = 0; i < data.length; i++) {

                        data[i].debit = 0;
                        data[i].credit = 0;

                        if (data[i].from == 'DS-' + this.dist_id) {
                            data[i].credit = data[i].ammount;
                            data[i].debit = 0;
                            this.totalCredit += parseInt(data[i].credit);
                        } else if (data[i].to == 'DS-' + this.dist_id) {
                            data[i].debit = data[i].ammount;
                            data[i].credit = 0;
                            this.totalDebit += parseInt(data[i].debit);
                        }

                        if (i == 0) {
                            data[i].balance = parseInt(data[i].credit) - parseInt(data[i].debit);
                        } else {
                            data[i].balance = (parseInt(data[i - 1].balance) + parseInt(data[i].credit)) - parseInt(data[i].debit);
                        }
                    }
                  this.loader = false;
                  this.showTable = true;
              
        } else {
            this.loadDistWiseAllDealerLedger();
        }
    }

    sortedOrderOfColumn = (x: any) => {
        this.orderBy = x;
    }


}

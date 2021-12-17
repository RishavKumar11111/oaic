import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { CommonService } from 'src/app/services/common.service';

@Component({
  selector: 'app-project-wise',
  templateUrl: './project-wise.component.html',
  styleUrls: ['./project-wise.component.css']
})
export class ProjectWiseComponent implements OnInit {
  project_no:any;
  showCashBook: any = false;
  fin_year: any ;
  header: any;
  dist_id: any;
  schem_list: any = [];
  schem: any;
  project_no_list: any = [];
  allData: any;
  totalCredit: any;
  totalDebit: any;
  loader: boolean = false;

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private http: HttpClient
  ) { 
    this.layoutService.setBreadcrumb('Ledger / Project wise ledger');
    this.dist_id = layoutService.getDistrictID();
  }

  ngOnInit(): void {
  }

  changeFinancialYear(financialYear: string) {
    this.fin_year = financialYear;
    this.loadAllScheme();
    this.header = true;
  }

  loadAllScheme = async () => {
    let response = await this.service.get('/accountant/getAllSchema');
    this.schem_list = response;
  }

  loadProjectNos = async() => {
        if ((this.schem && this.fin_year) != undefined) {
            switch (this.schem.schem_id) {
                case "1":
                    {
                        let response = await this.service.get('/accountant/getAllPermitNos?dist_id=' + this.dist_id);
                        this.project_no_list = response;
                        break;
                    }
                case "2":
                    {
                        let response2 = await this.service.get('/accountant/getAllClusterIdsForExpenditure?dist_id=' + this.dist_id);
                        this.project_no_list = response2;
                        break;
                    }
            }
        }
    };
   loadCashBook = async() => {
        switch (this.schem.schem_id) {
            case "1":
                {
                   let response = await this.service.get('/accountant/getCashBookData?permit_no=' + this.project_no.reference_no)
                   
                        this.showCashBook = true;
                        this.allData = response;

                        let data = response;
                        this.totalCredit = 0;
                        this.totalDebit = 0;
                        data.filter((e: any) => e.date = new Date(e.date));
                        data.sort((a: any, b: any) => a.date - b.date);
                        for (let i = 0; i < data.length; i++) {

                            data[i].date = new Date(data[i].date);
                            if (data[i].to == 'DS-' + this.dist_id) {
                                data[i].credit = data[i].ammount;
                                data[i].debit = 0;
                                this.totalCredit += parseInt(data[i].credit);
                            } else if (data[i].from == 'DS-' + this.dist_id) {
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
                  
                    break;
                }
            case "2":
                {
                    // let response2 = await $http.get('/accountant/getClusterWiseCBData?cluster_id='+ $scope.project_no.project_no);
                    // console.log(response2.data);
                    this.allData = [];
                    break;
                }
        }
    }

}

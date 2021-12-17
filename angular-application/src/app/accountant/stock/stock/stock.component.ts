import { Component, OnInit } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { CommonService } from 'src/app/services/common.service';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-stock',
  templateUrl: './stock.component.html',
  styleUrls: ['./stock.component.css']
})
export class StockComponent implements OnInit {

  constructor(
    private layoutService: LayoutService,
    private service: CommonService,
    private toastr: ToastrService
  ) { 
    this.layoutService.setBreadcrumb('Miscellaneous expences');
    this.loadFinYear();
  }
  ngOnInit(): void {
  }



  showDetails = false;
    loader = false;
    fin_year: string = '';
    fin_year_list: any = [];
    stockData: any= [];
    loadFinYear = async () => {
      this.fin_year_list = await this.service.get('/api/getFinYear');
      this.loadStock();
    }
    loadStock = async () => {
        this.loader = true;
        this.stockData = await this.service.get('/accountant/getAllStocks?fin_year='+this.fin_year);
        this.showDetails = true;
        this.stockData.forEach( (element: any) => {
                if(element.status == 'delivered_to_customer')
                    element.out = 'OUT';
                else
                    element.in = 'IN';
            })
            this.loader = false;
    }


}

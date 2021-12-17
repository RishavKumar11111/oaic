import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-farmer-money-receipt',
  templateUrl: './farmer-money-receipt.component.html',
  styleUrls: ['./farmer-money-receipt.component.css']
})
export class FarmerMoneyReceiptComponent implements OnInit {

  @Input() data: any = {};
  @Input() DMDetails: any ={};
  constructor() { }

  ngOnInit(): void {
  }

}

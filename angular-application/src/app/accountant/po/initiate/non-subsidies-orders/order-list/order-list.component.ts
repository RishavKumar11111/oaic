import { FormArray } from '@angular/forms';
import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-order-list',
  templateUrl: './order-list.component.html',
  styleUrls: ['./order-list.component.css']
})
export class OrderListComponent implements OnInit {

  @Input() orderList: FormArray = new FormArray([]);
  constructor() { }

  ngOnInit(): void {
  }



  removeOrder = (index: number) => {
      this.orderList.value.splice(index, 1);

  }
}

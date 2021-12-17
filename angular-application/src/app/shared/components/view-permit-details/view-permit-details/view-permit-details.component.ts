import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-view-permit-details',
  templateUrl: './view-permit-details.component.html',
  styleUrls: ['./view-permit-details.component.css']
})
export class ViewPermitDetailsComponent implements OnInit {

  constructor() { }

  @Input() order: any = {}

  ngOnInit(): void {
  }

}

import { Component, OnInit } from '@angular/core';
import { LayoutService } from 'src/app/services/layout/layout.service';

@Component({
  selector: 'app-page-heading',
  templateUrl: './page-heading.component.html',
  styleUrls: ['./page-heading.component.css']
})
export class PageHeadingComponent implements OnInit {

  breadcrumbName: string = '';
  constructor(private layoutService: LayoutService) { 
    this.layoutService.breadcrumb.subscribe((value: any) => this.breadcrumbName = value);
  }

  ngOnInit(): void {
  }

}

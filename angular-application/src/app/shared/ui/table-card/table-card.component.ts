import { AfterViewInit, Component, ViewChild } from '@angular/core';

@Component({
  selector: 'app-table-card',
  templateUrl: './table-card.component.html',
  styleUrls: ['./table-card.component.css']
})
export class TableCardComponent implements AfterViewInit {

  @ViewChild('modalFooter', { static: false }) modalFooter: any;
  displayFooter: boolean = true;
  constructor() { }

  ngAfterViewInit() {
    // if the modal footer does not have any child nodes, make displayFooter false
    setTimeout(() => {
      if (this.modalFooter.nativeElement.children.length === 0) {
        this.displayFooter = false;
      }
    });
  } 
}

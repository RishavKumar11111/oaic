import { AfterViewInit, Component, ElementRef, ViewChild } from '@angular/core';

@Component({
  selector: 'app-normal-card',
  templateUrl: './normal-card.component.html',
  styleUrls: ['./normal-card.component.css']
})
export class NormalCardComponent implements AfterViewInit {

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

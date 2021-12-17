import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PoComponent } from './po.component';
import { NgxPrintModule } from 'ngx-print';



@NgModule({
  declarations: [
    PoComponent
  ],
  imports: [
    CommonModule,
    NgxPrintModule,
  ],
  exports: [
    PoComponent
  ]
})
export class PoModule { }

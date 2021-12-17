import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NormalCardComponent } from './normal-card.component';



@NgModule({
  declarations: [
    NormalCardComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    NormalCardComponent
  ]
})
export class NormalCardModule { }

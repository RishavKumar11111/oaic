import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EnterItemDetailsFormComponent } from './enter-item-details-form.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    EnterItemDetailsFormComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    EnterItemDetailsFormComponent
  ]
})
export class EnterItemDetailsFormModule { }

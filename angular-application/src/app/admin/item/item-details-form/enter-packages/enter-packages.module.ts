import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EnterPackagesComponent } from './enter-packages.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';



@NgModule({
  declarations: [
    EnterPackagesComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    EnterPackagesComponent
  ]
})
export class EnterPackagesModule { }

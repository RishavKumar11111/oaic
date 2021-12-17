import { HttpClientTestingModule } from '@angular/common/http/testing';
import { FormBuilder } from '@angular/forms';
import { ToastrModule } from 'ngx-toastr';

export const TestingModules = [
    HttpClientTestingModule,
    ToastrModule.forRoot()
]
export const TestingProviders = [
    FormBuilder
]
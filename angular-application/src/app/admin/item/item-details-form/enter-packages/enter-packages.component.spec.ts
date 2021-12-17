import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingProviders, TestingModules } from 'src/app/common/common.modules';

import { EnterPackagesComponent } from './enter-packages.component';

describe('EnterPackagesComponent', () => {
  let component: EnterPackagesComponent;
  let fixture: ComponentFixture<EnterPackagesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EnterPackagesComponent ],
      imports: [TestingModules],
      providers: [TestingProviders]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EnterPackagesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

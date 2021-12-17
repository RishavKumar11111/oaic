import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { RePrintComponent } from './re-print.component';

describe('RePrintComponent', () => {
  let component: RePrintComponent;
  let fixture: ComponentFixture<RePrintComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RePrintComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RePrintComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

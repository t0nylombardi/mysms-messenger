import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'phoneFormat',
  standalone: true
})
export class PhoneFormatPipe implements PipeTransform {
  transform(value: string): string {
    const digits = value.replace(/\D/g, '');

    if (digits.length !== 11 || !digits.startsWith('1')) {
      return value;
    }

    const country = digits[0];
    const area = digits.slice(1, 4);
    const prefix = digits.slice(4, 7);
    const line = digits.slice(7, 11);

    return `${area}-${prefix}-${line}`;
  }
}

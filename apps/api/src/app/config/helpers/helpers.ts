export function isTrue(value: any) {
  return value?.toString().toLowerCase() === 'true';
}

export function splitTrimFilter<T = string>(value: string | T[], delimiter = ',') {
  const content = typeof value === 'string' ? value.split(delimiter) : Array.isArray(value) ? value : [value];
  return content.map((item) => item.trim()).filter((item) => item.length > 0);
}

export function removeUndefinedFields<T>(obj: T): T {
  if (obj === null || obj === undefined) {
    return undefined;
  }

  if (typeof obj !== 'object') {
    return obj;
  }

  const newObj: any = Array.isArray(obj) ? [] : {};

  for (const key in obj) {
    if (Object.hasOwn(obj, key)) {
      const value = removeUndefinedFields(obj[key]);
      if (value !== undefined) {
        newObj[key] = value;
      }
    }
  }

  return newObj;
}

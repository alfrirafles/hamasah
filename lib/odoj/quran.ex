defmodule Odoj.Quran do

  def list_contents do
    [
      %{surah: "Al-Fatihah", verse_count: 7},
      %{surah: "Al-Baqarah", verse_count: 286},
      %{surah: "Ali 'Imran", verse_count: 200},
      %{surah: "An-Nisa'", verse_count: 176},
      %{surah: "Al-Ma'idah", verse_count: 120},
      %{surah: "Al-An'am", verse_count: 165},
      %{surah: "Al-A'raf", verse_count: 206},
      %{surah: "Al-Anfal", verse_count: 75},
      %{surah: "At-Taubah", verse_count: 129},
      %{surah: "Yunus", verse_count: 109},
      %{surah: "Hud", verse_count: 123},
      %{surah: "Yusuf", verse_count: 111},
      %{surah: "Ar-Ra'd", verse_count: 43},
      %{surah: "Ibrahim", verse_count: 52},
      %{surah: "Al-Hijr", verse_count: 99},
      %{surah: "An-Nahl", verse_count: 128},
      %{surah: "Al-Isra'", verse_count: 111},
      %{surah: "Al-Kahf", verse_count: 110},
      %{surah: "Maryam", verse_count: 98},
      %{surah: "Taha", verse_count: 135},
      %{surah: "Al-Anbiya'", verse_count: 112},
      %{surah: "Al-Hajj", verse_count: 78},
      %{surah: "Al-Mu'minun", verse_count: 118},
      %{surah: "An-Nur", verse_count: 64},
      %{surah: "Al-Furqan", verse_count: 77},
      %{surah: "Asy-Syu'ara'", verse_count: 227},
      %{surah: "An-Naml", verse_count: 93},
      %{surah: "Al-Gasas", verse_count: 88},
      %{surah: "Al-'Ankabut", verse_count: 69},
      %{surah: "Ar-Rum", verse_count: 60},
      %{surah: "Luqman", verse_count: 34},
      %{surah: "As-Sajdah", verse_count: 30},
      %{surah: "Al-Ahzab", verse_count: 73},
      %{surah: "Saba'", verse_count: 54},
      %{surah: "Fatir", verse_count: 45},
      %{surah: "Yasin", verse_count: 83},
      %{surah: "As-Saffat", verse_count: 182},
      %{surah: "Sad", verse_count: 88},
      %{surah: "Az-Zumar", verse_count: 75},
      %{surah: "Gafir", verse_count: 85},
      %{surah: "Fussilat", verse_count: 54},
      %{surah: "Asy-Syura", verse_count: 53},
      %{surah: "Az-Zukhruf", verse_count: 89},
      %{surah: "Ad-Dukhan", verse_count: 59},
      %{surah: "Al-Jasiyah", verse_count: 37},
      %{surah: "Al-Ahqaf", verse_count: 35},
      %{surah: "Muhammad", verse_count: 38},
      %{surah: "Al-Fath", verse_count: 29},
      %{surah: "Al-Hujurat", verse_count: 18},
      %{surah: "Qaf", verse_count: 45},
      %{surah: "Az-Zariyat", verse_count: 60},
      %{surah: "At-Tur", verse_count: 49},
      %{surah: "An-Najm", verse_count: 62},
      %{surah: "Al-Gamar", verse_count: 55},
      %{surah: "Ar-Rahman", verse_count: 78},
      %{surah: "Al-Waqi'ah", verse_count: 96},
      %{surah: "Al-Hadid", verse_count: 29},
      %{surah: "Al-Mujadalah", verse_count: 22},
      %{surah: "Al-Hasyr", verse_count: 24},
      %{surah: "Al-Mumtahanah", verse_count: 13},
      %{surah: "As-Saff", verse_count: 14},
      %{surah: "Al-Jumu'ah", verse_count: 11},
      %{surah: "Al-Munafiqun", verse_count: 11},
      %{surah: "At-Tagabun", verse_count: 18},
      %{surah: "At-Talaq", verse_count: 12},
      %{surah: "At-Tahrim", verse_count: 12},
      %{surah: "Al-Mulk", verse_count: 30},
      %{surah: "Al-Galam", verse_count: 52},
      %{surah: "Al-Haqqah", verse_count: 52},
      %{surah: "Al-Ma'arij", verse_count: 44},
      %{surah: "Nuh", verse_count: 28},
      %{surah: "Al-Jinn", verse_count: 28},
      %{surah: "Al-Muzzammil", verse_count: 20},
      %{surah: "Al-Muddassir", verse_count: 56},
      %{surah: "Al-Qiyamah", verse_count: 40},
      %{surah: "Al-Insan", verse_count: 31},
      %{surah: "Al-Mursalat", verse_count: 50},
      %{surah: "An-Naba'", verse_count: 40},
      %{surah: "An-Nazi'at", verse_count: 46},
      %{surah: "'Abasa", verse_count: 42},
      %{surah: "At-Takwir", verse_count: 29},
      %{surah: "Al-Infitar", verse_count: 19},
      %{surah: "Al-Mutaffifin", verse_count: 36},
      %{surah: "Al-Insyiqaq", verse_count: 25},
      %{surah: "Al-Buruj", verse_count: 22},
      %{surah: "At-Tariq", verse_count: 17},
      %{surah: "Al-A'la", verse_count: 19},
      %{surah: "Al-Gasyiyah", verse_count: 26},
      %{surah: "Al-Fajr", verse_count: 30},
      %{surah: "Al-Balad", verse_count: 20},
      %{surah: "Asy-Syams", verse_count: 15},
      %{surah: "Al-Lail", verse_count: 21},
      %{surah: "Ad-Duha", verse_count: 11},
      %{surah: "Asy-Syarh", verse_count: 8},
      %{surah: "At-Tin", verse_count: 8},
      %{surah: "Al-Alaq", verse_count: 19},
      %{surah: "Al-Qadr", verse_count: 5},
      %{surah: "Al-Bayyinah", verse_count: 8},
      %{surah: "Az-Zalzalah", verse_count: 8},
      %{surah: "Al-'Adiyat", verse_count: 11},
      %{surah: "Al-Qari'ah", verse_count: 11},
      %{surah: "At-Takasur", verse_count: 8},
      %{surah: "Al-'Asr", verse_count: 3},
      %{surah: "Al-Humazah", verse_count: 9},
      %{surah: "Al-Fil", verse_count: 5},
      %{surah: "Quraisy", verse_count: 4},
      %{surah: "Al-Ma'un", verse_count: 7},
      %{surah: "Al-Kausar", verse_count: 3},
      %{surah: "Al-Kafirun", verse_count: 6},
      %{surah: "An-Nasr", verse_count: 3},
      %{surah: "Al-Ahab", verse_count: 5},
      %{surah: "Al-Ikhlas", verse_count: 4},
      %{surah: "Al-Falaq", verse_count: 5},
      %{surah: "An-Nas", verse_count: 6}
    ]
  end

  def list_juz do
    [
      %{number: 1, surah_start: "Al-Fatihah", verse_start: 1, surah_end: "Al-Baqarah", verse_end: 141},
      %{number: 2, surah_start: "Al-Baqarah", verse_start: 142, surah_end: "Al-Baqarah", verse_end: 252},
      %{number: 3, surah_start: "Al-Baqarah", verse_start: 253, surah_end: "Ali 'Imran", verse_end: 92},
      %{number: 4, surah_start: "Ali 'Imran", verse_start: 93, surah_end: "An-Nisa'", verse_end: 23},
      %{number: 5, surah_start: "An-Nisa'", verse_start: 24, surah_end: "An-Nisa'", verse_end: 147},
      %{number: 6, surah_start: "An-Nisa'", verse_start: 148, surah_end: "Al-Ma'idah", verse_end: 81},
      %{number: 7, surah_start: "Al-Ma'idah", verse_start: 82, surah_end: "Al-An'am", verse_end: 110},
      %{number: 8, surah_start: "Al-An'am", verse_start: 111, surah_end: "Al-A'raf", verse_end: 87},
      %{number: 9, surah_start: "Al-A'raf", verse_start: 88, surah_end: "Al-Anfal", verse_end: 40},
      %{number: 10, surah_start: "Al-Anfal", verse_start: 41, surah_end: "At-Taubah", verse_end: 92},
      %{number: 11, surah_start: "At-Taubah", verse_start: 93, surah_end: "Hud", verse_end: 5},
      %{number: 12, surah_start: "Hud", verse_start: 6, surah_end: "Yusuf", verse_end: 52},
      %{number: 13, surah_start: "Yusuf", verse_start: 53, surah_end: "Ibrahim", verse_end: 52},
      %{number: 14, surah_start: "Al-Hijr", verse_start: 1, surah_end: "An-Nahl", verse_end: 128},
      %{number: 15, surah_start: "Al-Isra'", verse_start: 1, surah_end: "Al-Kahf", verse_end: 74},
      %{number: 16, surah_start: "Al-Kahf", verse_start: 75, surah_end: "Taha", verse_end: 135},
      %{number: 17, surah_start: "Al-Anbiya'", verse_start: 1, surah_end: "Al-Hajj", verse_end: 78},
      %{number: 18, surah_start: "Al-Mu'minun", verse_start: 1, surah_end: "Al-Furqan", verse_end: 20},
      %{number: 19, surah_start: "Al-Furqan", verse_start: 21, surah_end: "An-Naml", verse_end: 55},
      %{number: 20, surah_start: "An-Naml", verse_start: 56, surah_end: "Al-'Ankabut", verse_end: 45},
      %{number: 21, surah_start: "Al-'Ankabut", verse_start: 46, surah_end: "Al-Ahzab", verse_end: 30},
      %{number: 22, surah_start: "Al-Ahzab", verse_start: 31, surah_end: "Yasin", verse_end: 27},
      %{number: 23, surah_start: "Yasin", verse_start: 28, surah_end: "Az-Zumar", verse_end: 31},
      %{number: 24, surah_start: "Az-Zumar", verse_start: 32, surah_end: "Fussilat", verse_end: 46},
      %{number: 25, surah_start: "Fussilat", verse_start: 47, surah_end: "Al-Jasiyah", verse_end: 37},
      %{number: 26, surah_start: "Al-Ahqaf", verse_start: 1, surah_end: "Az-Zariyat", verse_end: 30},
      %{number: 27, surah_start: "Az-Zariyat", verse_start: 31, surah_end: "Al-Hadid", verse_end: 29},
      %{number: 28, surah_start: "Al-Mujadalah", verse_start: 1, surah_end: "At-Tahrim", verse_end: 12},
      %{number: 29, surah_start: "Al-Mulk", verse_start: 1, surah_end: "Al-Mursalat", verse_end: 50},
      %{number: 30, surah_start: "An-Naba'", verse_start: 1, surah_end: "An-Nas", verse_end: 6}
    ]
  end

  def list_verses(start_verse, end_verse, list \\ [])
  def list_verses(start_verse, end_verse, list) when start_verse != end_verse do
    list_verses(start_verse + 1, end_verse, [start_verse | list])
  end
  def list_verses(_start_verse, end_verse, list), do: Enum.reverse([end_verse | list])

  def find_juz_details(juz_number) do
    list_juz()
    |> Enum.find(fn %{number: number} -> number == juz_number end)
  end

  def find_surah(surah_name, :check) do
    result = list_contents()
             |> Enum.find(fn %{surah: name} -> name == surah_name end)
    case result do
      nil -> {:error, "not_found"}
      _ -> %{surah: surah_name, verse_count: verse_count} = result
           {:ok, surah_name, verse_count}
    end
  end

  def find_surah(surah_name, :get) do
    list_contents()
    |> Enum.find(fn %{surah: name} -> name == surah_name end)
  end

  def get_surah_index(name) do
    list_contents()
    |> Enum.find_index(fn %{surah: surah_name} -> surah_name == name end)
  end

  def split_by_juz(juz_number) do
    juz = find_juz_details(juz_number)
    list_contents()
    |> Enum.slice(
         get_surah_index(juz.surah_start),
         (get_surah_index(juz.surah_end) - get_surah_index(juz.surah_start)) + 1
       )
  end

  def verse_count(surah_name) do
    {:ok, _, verse_count} = find_surah(surah_name, :check)
    verse_count
  end

end
defmodule OdojWeb.TrackerLive do
  use OdojWeb, :live_view

  alias Odoj.Quran
  alias Odoj.Users
  alias Odoj.Timer

  def mount(_params, session, socket) do
    user = Users.get_member_by_session_token(session["member_token"])
           |> Users.preload_logs()
    most_recent_log = user.logs
                      |> Enum.sort_by(&(&1.date), {:desc, NaiveDateTime})
                      |> Enum.at(0)
    input_list = Quran.list_juz
    IO.inspect most_recent_log
    unless is_nil(most_recent_log) || most_recent_log.juz == 30 do
      list_juz = Enum.drop_while(input_list, fn element_map ->
          if most_recent_log.surah do
            element_map.number < most_recent_log.juz
            else
            element_map.number <= most_recent_log.juz
          end
      end)
      {:ok, assign(socket,
          member: user,
          list_juz: list_juz,
          latest_recite: most_recent_log,
          latest_recite_detail: Quran.find_juz_details(most_recent_log.juz),
          session_id: session["live_socket_id"],
          message: nil
          ),
          temporary_assigns: [message: nil]
        }
      else
      {:ok, assign(socket,
          member: user,
          list_juz: input_list,
          latest_recite: nil,
          latest_recite_detail: nil,
          session_id: session["live_socket_id"],
          message: nil
          ),
          temporary_assigns: [message: nil]
        }

    end
  end

  def handle_event("record-log", %{"member_id" => id} = params, socket) do
    id = String.to_integer(id)
    datetime = Timer.current_datetime
    juz_list = get_juz_input(params)
    if Enum.count(juz_list) != 0 do
      latest_surah_verse = get_juz_progress(juz_list, params)
                           |> List.first
                           |> Map.values
                           |> List.first
      unless latest_surah_verse == "" do
        [latest_juz | rest] = Enum.reverse(juz_list)
        [latest_surah, latest_verse] = latest_surah_verse
                                       |> String.split(":")
        Users.create_log(%{member_id: id,
                         date: datetime,
                         juz: latest_juz,
                         surah: latest_surah,
                         verse: latest_verse})
        for number <- rest do
          Users.create_log(%{member_id: id, date: datetime, juz: number})
        end
        else
        if Enum.count(juz_list) == 1 do
          Users.create_log(%{member_id: id, date: datetime, juz: List.first(juz_list)})
          else
          for number <- juz_list do
            Users.create_log(%{member_id: id, date: datetime, juz: number})
          end
        end
      end
      latest_recite = Users.list_logs |> Enum.reverse |> List.first
      {:noreply, assign(socket,
        latest_recite: latest_recite,
        latest_recite_detail: Quran.find_juz_details(latest_recite.juz),
        message: "Bacaan berhasil tercatat.")}
    else
      {:noreply, socket}
    end
  end

  def get_juz_progress(juz_list, params) do
    for map <- params do
      {key, value} = map
      filtering_key = "juz-" <> Integer.to_string(List.last(juz_list)) <> "-progress"
      if Map.has_key?(%{key => value}, filtering_key), do: Map.merge(%{}, %{key => value})
    end
    |> Enum.reject(fn element -> is_nil(element) end)
  end

  def get_juz_input(params) do
    Enum.reduce(
      params,
      %{},
      fn {key, value}, filtered_params ->
        Enum.reduce(
          1..30,
          filtered_params,
          fn number, acc ->
            number = "juz-#{number}"
            if Map.has_key?(%{key => value}, number) do
              Map.merge(filtered_params, %{key => value})
            else
              acc
            end
          end
        )
      end
    )
    |> Map.keys
    |> Enum.reduce(
         [],
         fn string, result_list ->
           "juz-" <> number = string
           [String.to_integer(number) | result_list]
         end
       )
    |> Enum.reverse
  end
end